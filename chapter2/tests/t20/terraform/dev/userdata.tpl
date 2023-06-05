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
cd /efs
sudo chmod go+rw .
#sudo mount -t efs -o tls ${EFS_ID}:/ .
sudo mkdir -p /etc/fsdata

# Write EFS ID to /etc/fsdata/fs_tld
echo "${EFS_ID}" | sudo tee /etc/fsdata/fs_tld > /dev/null

# Add EFS mount information to /etc/fstab
echo "${EFS_ID}.efs.us-east-2.amazonaws.com:/ /efs efs defaults,_netdev,tls,iam 0 0" | sudo tee -a /etc/fstab > /dev/null
sudo mount -a

# install wordpress
wget https://wordpress.org/latest.zip
unzip latest.zip
rm -rf latest.zip

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

                location ~ \.php\$ {
                        include fastcgi_params;
                        fastcgi_intercept_errors on;
                        fastcgi_pass php;
                        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
                        fastcgi_buffer_size 64k;
                        fastcgi_buffers 16 16k;
                }

                location /admin {
                        rewrite ^/admin(.*)\$ /wp-admin\$1 last;
                }

        }
}

EOF

# create wordpress config
cat > /efs/wordpress/wp-config.php <<EOF
<?php

define( 'DB_NAME', '${DB_NAME}' );
define( 'DB_USER', '${DB_USER}' );
define( 'DB_PASSWORD', '${DB_PASSWORD}' );
define( 'DB_HOST', '${DB_HOST}' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );

define( 'AUTH_KEY',         '${AUTH_KEY}' );
define( 'SECURE_AUTH_KEY',  '${SECURE_AUTH_KEY}' );
define( 'LOGGED_IN_KEY',    '${LOGGED_IN_KEY}' );
define( 'NONCE_KEY',        '${NONCE_KEY}' );
define( 'AUTH_SALT',        '${AUTH_SALT}' );
define( 'SECURE_AUTH_SALT', '${SECURE_AUTH_SALT}' );
define( 'LOGGED_IN_SALT',   '${LOGGED_IN_SALT}' );
define( 'NONCE_SALT',       '${NONCE_SALT}' );

define( 'WP_DEBUG', true);
define( 'DISALLOW_FILE_EDIT', false);
define( 'WP_TIMEOUT_NONCE', 60 * 60 * 24 );
define( 'FS_METHOD', 'direct');
define('WP_HOME','https://${SITE_URL}');
define('WP_SITEURL','https://${SITE_URL}');

if (\$_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https')
          \$_SERVER['HTTPS']='on';


\$table_prefix = 'wp_';

if ( ! defined( 'ABSPATH' ) ) {
        define( 'ABSPATH', __DIR__ . '/' );
}

require_once ABSPATH . 'wp-settings.php';
EOF

sudo systemctl restart nginx

sudo curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
sudo chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
cd wordpress
sudo mkdir wp-content/uploads
sudo chmod 755 wp-content/uploads
wp core install --url="https://${SITE_URL}" --title="My WordPress Terraform Task" --admin_user="admin" --admin_password="${WORDPRESS_PASSWORD}" --admin_email="admin@${SITE_URL}"
