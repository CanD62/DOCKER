FROM php:7.2-apache
RUN docker-php-ext-install mysqli 
RUN docker-php-ext-enable mysqli

RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini

RUN echo "session.save_handler = files" >> /usr/local/etc/php/php.ini && \
    echo "session.save_path = /tmp" >> /usr/local/etc/php/php.ini && \
    echo "session.use_strict_mode = 1" >> /usr/local/etc/php/php.ini && \
    echo "session.use_cookies = 1" >> /usr/local/etc/php/php.ini && \
    echo "session.use_only_cookies = 1" >> /usr/local/etc/php/php.ini && \
    echo "session.name = PHPSESSID" >> /usr/local/etc/php/php.ini

RUN sed -i '/<VirtualHost \*:80>/i SetEnv HTTPS on' /etc/apache2/sites-enabled/000-default.conf

RUN a2enmod rewrite
RUN service apache2 restart
#COPY . /var/www/html/
