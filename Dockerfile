FROM php:7.2.2-apache

# add PHP, extensions and third-party software
RUN apt-get update \
    && apt-get install -y \
        libapache2-mod-xsendfile \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        dcraw \
        libcurl4-gnutls-dev \
        locales \
        graphicsmagick \
        mysql-client \
        wget \
        unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) pdo_mysql exif zip gd opcache

# set recommended PHP.ini settings
# see http://docs.filerun.com/php_configuration
COPY filerun-optimization.ini /usr/local/etc/php/conf.d/

# Install ionCube
RUN wget https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
 && tar xvfz ioncube_loaders_lin_x86-64.tar.gz \
 && PHP_EXT_DIR=$(php-config --extension-dir) \
 && cp "ioncube/ioncube_loader_lin_7.2.so" $PHP_EXT_DIR \
 && echo "zend_extension=ioncube_loader_lin_7.2.so" >> /usr/local/etc/php/conf.d/00_ioncube_loader_lin_7.2.ini \
 && rm -rf ioncube ioncube_loaders_lin_x86-64.tar.gz

# Enable Apache XSendfile
RUN { \
		echo 'XSendFile On'; \
		echo; \
		echo 'XSendFilePath /user-files'; \
	} | tee "/etc/apache2/conf-available/filerun.conf" \
	&& a2enconf filerun

# Install FileRun
RUN wget -O /filerun.zip https://www.filerun.com/download-latest-php71 \
 && mkdir /user-files \
 && chown www-data:www-data /user-files

ENV DB_TYPE mysql
ENV DB_HOST db
ENV DB_PORT 3306
ENV DB_NAME filerun
ENV DB_USER filerun
ENV DB_PASS filerun

COPY db.sql /filerun.setup.sql
COPY autoconfig.php /

VOLUME ["/var/www/html", "/user-files"]

COPY ./entrypoint.sh /
COPY ./wait-for-it.sh /
COPY ./import-db.sh /
RUN chmod +x /wait-for-it.sh
RUN chmod +x /import-db.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
