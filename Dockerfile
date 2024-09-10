FROM alpine:latest

# Set timezone and environment
ENV REGION=Asia/Jakarta \
    PATH="/composer/vendor/bin:$PATH" \
    COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_VENDOR_DIR=/var/www/app/vendor \
    COMPOSER_HOME=/composer

# Set timezone
RUN ln -sf /usr/share/zoneinfo/${REGION} /etc/localtime

# Install packages and PHP extensions in one command
RUN apk --no-cache add \
    nginx php82 php82-phar php82-iconv php82-openssl curl supervisor dos2unix \
    nodejs npm \
    && cp /usr/bin/php82 /usr/bin/php

# Install Composer
RUN curl -sS https://getcomposer.org/installer | \
    php -- --install-dir=/usr/local/bin --filename=composer \
    && composer --ansi --version --no-interaction --no-dev

# Copy configuration files
COPY ./docker/php.ini /etc/php82/php.ini
COPY ./docker/supervisord.conf /etc/supervisord.conf

EXPOSE 80

# Start supervisor
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
