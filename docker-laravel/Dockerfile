FROM php:8.2-apache
# set main params
ENV APP_HOME /var/www/html
ARG HOST_UID=1000
ARG HOST_GID=1000
ENV USERNAME=www-data


# install all the dependencies and enable PHP modules
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
      procps \
      nano \
      git \
      unzip \
      libicu-dev \
      zlib1g-dev \
      libxml2 \
      libxml2-dev \
      libreadline-dev \
     # supervisor \
      #cron \
      sudo \
      libzip-dev \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
    && docker-php-ext-configure intl \
    && docker-php-ext-install \
      pdo_mysql \
      sockets \
      intl \
      opcache \
      zip \
    && rm -rf /tmp/* \
    && rm -rf /var/list/apt/* \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

RUN echo "ServerName laravel-app.local" >> /etc/apache2/apache2.conf

ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# 3. mod_rewrite for URL rewrite and mod_headers for .htaccess extra headers like Access-Control-Allow-Origin-
RUN a2enmod rewrite headers

# 4. Start with base PHP config, then add extensions.
#RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

	
# create document root, fix permissions for www-data user and change owner to www-data
RUN mkdir -p $APP_HOME/public && \
    mkdir -p /home/$USERNAME && chown $USERNAME:$USERNAME /home/$USERNAME \
    && usermod -o -u $HOST_UID $USERNAME -d /home/$USERNAME \
    && groupmod -o -g $HOST_GID $USERNAME \
    && chown -R ${USERNAME}:${USERNAME} $APP_HOME
      
RUN a2enmod rewrite \
&& chmod 755 /var/www/html -R \
      && chown www-data:www-data /var/www/html 
COPY composer.json composer.lock ./
# Copy existing application directory contents
COPY . .
# install composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN chmod +x /usr/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER 1

# set working directory
WORKDIR $APP_HOME

RUN chown -R ${USERNAME}:${USERNAME} storage 
RUN chmod -R 775 storage 

USER ${USERNAME}
RUN composer install --no-interaction --no-scripts --no-progress
RUN php artisan key:generate && echo "Key generated successfully"
#RUN php artisan migrate:fresh --seed && echo "Migration and seeding completed successfully"
RUN php artisan storage:link && echo "Storage link created successfully"

#COPY --chown=${USERNAME}:${USERNAME} ./run.sh /var/www/html/run.sh
#RUN chmod +x /var/www/html/run.sh
#ENTRYPOINT ["bash", "/var/www/html/run.sh"]
CMD ["php", "artisan", "migrate", "--force"]
CMD ["apache2-foreground"]
USER root
#RUN service apache2 restart
