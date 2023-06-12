#!/bin/bash
# userdata file

# install
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo yum install -y https://dev.mysql.com/get/mysql80-community-release-el8-5.noarch.rpm
sudo yum install nginx php php-fpm amazon-ssm-agent amazon-efs-utils nfs-utils gcc openssl-devel php-mysqli -y

# start all
sudo systemctl start nginx
sudo systemctl start php-fpm
sudo systemctl start amazon-ssm-agent
sudo systemctl start mysqld

# enable all
sudo systemctl enable nginx
sudo systemctl enable php-fpm
sudo systemctl enable amazon-ssm-agent
sudo systemctl enable mysqld

# deps
sudo wget https://bootstrap.pypa.io/get-pip.py -O /tmp/get-pip.py
sudo python3 /tmp/get-pip.py
sudo pip3 install botocore

# efs
sudo mkdir /efs
sudo mkdir -p /etc/fsdata

# Write EFS ID to /etc/fsdata/fs_tld
echo "${efs_id}" | sudo tee /etc/fsdata/fs_tld > /dev/null

# Add EFS mount information to /etc/fstab
echo "${efs_id}.efs.us-east-2.amazonaws.com:/ /efs efs defaults,_netdev,tls,iam 0 0" | sudo tee -a /etc/fstab > /dev/null
sudo mount -a

# create nginx config
cat > /etc/nginx/nginx.conf <<EOF
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log notice;
pid /run/nginx.pid;

events {
  worker_connections 1024;
}

http {
        default_type       application/octet-stream;
        sendfile           on;
        keepalive_timeout  3;
        access_log  /var/log/nginx/access.log;

        upstream php {
          server unix:/run/php-fpm/www.sock;
        }

        server {
                server_name _;
                root /efs/wordpress;
                client_max_body_size 50M;
                index index.php;
                include mime.types;
                types_hash_max_size 2048;
                types_hash_bucket_size 128;

                location ~ \.php$ {
                        include fastcgi_params;
                        fastcgi_intercept_errors on;
                        fastcgi_pass php;
                        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
                        fastcgi_buffer_size 64k;
                        fastcgi_buffers 16 16k;
                }

                location /admin {
                        rewrite ^/admin(.*)$ /wp-admin\$1 last;
                }

        }
}
EOF

sudo systemctl restart nginx

# install wordpress
cd /efs

if [ ! -d "wordpress" ]; then
  sudo mkdir wordpress
else
  # If the efs wordpress directory already exists, it means that the installation is already being performed by another EC2 instance, so we exit.
  exit 1
fi

sudo chown ssm-user:ssm-user wordpress/
sudo chmod go+rw wordpress
wget https://wordpress.org/latest.zip
unzip latest.zip
rm -rf latest.zip

# create wordpress config
cat > /efs/wordpress/wp-config.php <<EOF
<?php

define( 'DB_NAME',            '${db_name}' );
define( 'DB_USER',            '${db_user}' );
define( 'DB_PASSWORD',        '${db_password}' );
define( 'DB_HOST',            '${db_host}' );
define( 'DB_CHARSET',         'utf8' );
define( 'DB_COLLATE',         '' );

define( 'AUTH_KEY',           '${auth_key}' );
define( 'SECURE_AUTH_KEY',    '${secure_auth_key}' );
define( 'LOGGED_IN_KEY',      '${logged_in_key}' );
define( 'NONCE_KEY',          '${nonce_key}' );
define( 'AUTH_SALT',          '${auth_salt}' );
define( 'SECURE_AUTH_SALT',   '${secure_auth_salt}' );
define( 'LOGGED_IN_SALT',     '${logged_in_salt}' );
define( 'NONCE_SALT',         '${nonce_salt}' );

define( 'WP_DEBUG',           true);
define( 'DISALLOW_FILE_EDIT', false);
define( 'WP_TIMEOUT_NONCE',   60 * 60 * 24 );
define( 'FS_METHOD',          'direct');
define('WP_HOME',             'https://${site_url}');
define('WP_SITEURL',          'https://${site_url}');

if (\$_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https')
          \$_SERVER['HTTPS']='on';


\$table_prefix = 'wp_';

if ( ! defined( 'ABSPATH' ) ) {
        define( 'ABSPATH', __DIR__ . '/' );
}

require_once ABSPATH . 'wp-settings.php';
EOF

sudo curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
sudo chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
cd wordpress
sudo mkdir wp-content/uploads
sudo chmod 755 wp-content/uploads
wp core install --url="https://${site_url}" --title="My WordPress Terraform Task" --admin_user="admin" --admin_password="${wordpress_password}" --admin_email="admin@${site_url}"
sudo chown -R nginx:nginx .
