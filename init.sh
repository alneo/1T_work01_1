#!/bin/bash
php artisan migrate
php-fpm -F &
nginx -g "daemon off;"
