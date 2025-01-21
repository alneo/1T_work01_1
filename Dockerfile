FROM php:8.2-fpm

#RUN echo "UTC+3" > /etc/timezone
RUN apt-get update && apt-get install -y nginx

COPY ./www.conf /usr/local/etc/php-fpm.d/www.conf
#RUN chown -R www-data:www-data /usr/local/etc/php-fpm.d/www.conf
#RUN chown -R www-data:www-data /var/run
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    curl \
    unzip \
    git \
    libzip-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libpq-dev  \
    nodejs \
    npm \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pgsql pdo_pgsql pdo_mysql mbstring exif pcntl bcmath gd zip intl opcache

COPY ./php.ini /usr/local/etc/php
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN chown -R www-data:www-data /var/lib/nginx
RUN chown -R www-data:www-data /run


WORKDIR /var/www/html
RUN rm -rf /var/www/html

# Скачивание Laravel с помощью Composer
RUN composer create-project --prefer-dist laravel/laravel=^11.0 ./
RUN composer install

COPY ./html/.env /var/www/html/.env

RUN chown -R www-data:www-data /var/www
#RUN composer require laravel/breeze

# Была ошибка curl error 28 while downloading https://repo.packagist.org/p2/laravel/ui.json: Connection timed out after 10006 milliseconds
RUN composer self-update
RUN composer require laravel/ui --dev
RUN php artisan ui bootstrap --auth

RUN php artisan config:cache
RUN php artisan route:cache
RUN php artisan view:cache
#RUN php artisan migrate
#ENV WEB_DOCUMENT_ROOT /public
#USER root
ADD init.sh /
RUN chmod +x /init.sh
USER www-data
CMD ["/init.sh"]
#COPY ./html /var/www/html
#EXPOSE 9000