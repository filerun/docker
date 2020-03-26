FROM php:7.3.6-apache

ENV FR_DB_HOST=db \
    FR_DB_PORT=3306 \
    FR_DB_NAME=filerun \
    FR_DB_USER=filerun \
    FR_DB_PASS=filerun \
    APACHE_RUN_USER=user \
    APACHE_RUN_USER_ID=1000 \
    APACHE_RUN_GROUP=user \
    APACHE_RUN_GROUP_ID=1000

VOLUME ["/var/www/html", "/user-files"]

COPY filerun-optimization.ini /usr/local/etc/php/conf.d/
COPY autoconfig.php entrypoint.sh wait-for-it.sh import-db.sh filerun.setup.sql /

# add PHP, extensions and third-party software
RUN apt-get update \
    && apt-get install -y \
        libapache2-mod-xsendfile \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libldap2-dev \
        libxml2-dev \
        libzip-dev \
        libcurl4-gnutls-dev \
        dcraw \
        locales \
        graphicsmagick \
        ffmpeg \
        mysql-client \
        unzip \
        cron \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure zip --with-libzip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu \
    && docker-php-ext-install -j$(nproc) pdo_mysql exif zip gd opcache ldap \
    && echo Install ionCube \
    && curl -O http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
    && tar xvfz ioncube_loaders_lin_x86-64.tar.gz \
    && PHP_EXT_DIR=$(php-config --extension-dir) \
    && cp "ioncube/ioncube_loader_lin_7.3.so" $PHP_EXT_DIR \
    && echo "zend_extension=ioncube_loader_lin_7.3.so" >> /usr/local/etc/php/conf.d/00_ioncube_loader_lin_7.3.ini \
    && rm -rf ioncube ioncube_loaders_lin_x86-64.tar.gz \
    && echo Enable Apache XSendfile \
    && echo "{ \
        echo 'XSendFile On'; \
        echo; \
        echo 'XSendFilePath /user-files'; \
    }" | tee "/etc/apache2/conf-available/filerun.conf" \
    && a2enconf filerun \
    && echo Download FileRun installation package \
    && curl -o /filerun.zip -L https://filerun.com/download-latest-php73 \
    && chown www-data:www-data /user-files \
    && chmod +x /wait-for-it.sh /import-db.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
