FROM vimagick/mantisbt:latest

ENV APP_HOME /var/www/html

RUN apt-get update -y && apt-get install -y \
vim \
unzip \
libzip-dev \
zip \
git && \
apt-get clean

  # set working directory
RUN rm -r $APP_HOME

  # change uid and gid of apache to docker user uid/gid
RUN usermod -u 1000 www-data && groupmod -g 1000 www-data
RUN chown -R www-data:www-data $APP_HOME

  # install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

  # set working directory
WORKDIR $APP_HOME

  # create composer folder for user www-data
RUN mkdir -p /var/www/.composer && chown -R www-data:www-data /var/www/.composer
RUN mkdir -p /var/www/.viminfo && chown -R www-data:www-data /var/www/.viminfo

USER www-data

  # copy source files
COPY --chown=www-data:www-data . $APP_HOME/

USER root

CMD ["apache2-foreground"]
