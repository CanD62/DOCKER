FROM reg.pcs.my.id/base/php73-apache:1.0

COPY php.ini /usr/local/etc/php/php.ini
COPY . /var/www/html

RUN chown -R www-data:www-data /var/www/html \
 && find /var/www/html -type d -exec chmod 755 {} \; \
 && find /var/www/html -type f -exec chmod 644 {} \;

WORKDIR /var/www/html


# Base image untuk PHP dan Apache
FROM reg.pcs.my.id/base/php73-apache:1.0 AS base

# Salin konfigurasi PHP
COPY php.ini /usr/local/etc/php/php.ini

# Buat direktori kerja
WORKDIR /var/www/html

# Salin hanya file dependensi terlebih dahulu (kalau pakai Composer, npm, dsb)
# COPY composer.json composer.lock ./        # (aktifkan kalau pakai Composer)
# RUN composer install --no-dev --prefer-dist --no-interaction

# Salin kode aplikasi terakhir supaya layer sebelumnya bisa dicache
COPY --chown=www-data:www-data . .

# RUN mkdir -p files uploads && \
#     chown -R www-data:www-data files uploads

# Set permission
# RUN find . -type d -exec chmod 755 {} + && \
#     find . -type f -exec chmod 644 {} +
