#!/bin/bash
# Task 11 - slow php reporting page
set -eo pipefail

# Start php-fpm in foreground mode
php-fpm -F --fpm-config $(pwd)/.php.fpm.d/php-fpm.conf &

# Start nginx in foreground mode
nginx -c $(pwd)/nginx-fpm.conf &

# Test with curl
time curl -L http://localhost/reports/fast
time curl -L http://localhost/reports/slow
