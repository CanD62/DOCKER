FROM reg.pcs.my.id/base/php73-apache:1.0

COPY php.ini /usr/local/etc/php/php.ini
COPY . /var/www/html

RUN chown -R www-data:www-data /var/www/html \
 && find /var/www/html -type d -exec chmod 755 {} \; \
 && find /var/www/html -type f -exec chmod 644 {} \;

WORKDIR /var/www/html
