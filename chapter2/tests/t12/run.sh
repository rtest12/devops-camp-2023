#!/bin/bash
#
# Task 12 - 500 error handling
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
sudo -u "${SUDO_USER}" mkdir -p /tmp/nginx/certs
cp -r ./ /tmp/nginx/

# Set permissions
chmod 755 /tmp/nginx/

# Set ownership, no recursion
chown nginx:nginx /tmp/nginx/


# mkcert generate certs
sudo -u "${SUDO_USER}" mkcert -key-file /tmp/nginx/certs/key.pem -cert-file /tmp/nginx/certs/cert.pem localhost 127.0.0.1


# Kill any running instances of nginx and wsgi
echo "Stopping any running instances of nginx and wsgi..."
sudo killall wsgi &> /dev/null && sudo killall nginx &> /dev/null

# Wait for services to stop
sleep 2

# Start nginx in foreground mode
nginx -g "daemon off;" -c "$(pwd)/nginx.conf" &


# Start uwsgi in foreground mode
sudo -u "${SUDO_USER}" uwsgi --ini app.ini --no-orphans

# Wait for services to start
sleep 2


# Test with curl
http GET https://localhost/changelog
http POST https://localhost/changelog changelog="lecture about pycamp"
