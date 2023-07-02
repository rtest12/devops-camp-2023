#!/bin/bash
#
# Task 11 - slow php reporting page
set -eo pipefail


# Check if nginx user exists, create if not
if ! id -u nginx > /dev/null 2>&1; then
  echo "Creating nginx user..."
  # Create nginx user with restricted shell (/sbin/nologin)
  useradd -r -s /sbin/nologin nginx
fi

if ! command -v mkcert > /dev/null 2>&1; then
  echo "Mkcert not found. Please install it."
  exit 1
fi


# Create necessary folders and files.
mkdir -p /tmp/camp/reports
sudo -u "${SUDO_USER}" mkdir -p /tmp/certs
cp -r ./reports/ /tmp/camp/


# Set permissions
chmod -R 755 /tmp/camp/

# Set ownership
chown -R nginx:nginx /tmp/camp/

# mkcert generate certs
sudo -u "${SUDO_USER}" mkcert -key-file /tmp/certs/key.pem -cert-file /tmp/certs/cert.pem camp-php.local localhost 127.0.0.1


# Kill any running instances of nginx and php-fpm
echo "Stopping any running instances of nginx and php-fpm..."
sudo killall php-fpm8.1 &> /dev/null && sudo killall nginx &> /dev/null

# Wait for services to stop
sleep 1

# Start nginx in foreground mode
nginx -g "daemon off;" -c "$(pwd)/nginx.conf" &


# Start php-fpm in foreground mode
/usr/sbin/php-fpm8.1 -F --php-ini "$(pwd)/php.ini" --fpm-config "$(pwd)/php-fpm.conf" -p "$(pwd)" &

# Wait for services to start
sleep 2

# Test with curl
time curl -L https://localhost/reports/fast
time curl -L https://localhost/reports/slow
