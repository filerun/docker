FROM php:7.4-apache
ENV FR_DB_HOST=db \
    FR_DB_PORT=3306 \
    FR_DB_NAME=filerun \
    FR_DB_USER=filerun \
    FR_DB_PASS=filerun \
    APACHE_RUN_USER=user \
    APACHE_RUN_USER_ID=1000 \
    APACHE_RUN_GROUP=user \
    APACHE_RUN_GROUP_ID=1000 \
    LIBVIPS_VERSION="8.12.1" \
    LIBREOFFICE_VERSION="7.1.8"
VOLUME ["/var/www/html", "/user-files"]
# set recommended PHP.ini settings
# see https://docs.filerun.com/php_configuration
COPY filerun-optimization.ini /usr/local/etc/php/conf.d/
COPY autoconfig.php entrypoint.sh wait-for-it.sh import-db.sh filerun.setup.sql supervisord.conf /

# add PHP, extensions and third-party software
RUN apt-get update \
    && apt-get install -y \
        libapache2-mod-xsendfile \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libtiff-dev \
        libwebp-dev \
        libgif-dev \
        librsvg2-dev \
        libldap2-dev \
        libxml2-dev \
        libzip-dev \
        libcurl4-gnutls-dev \
        libosmesa6-dev \
        libexif-dev \
        libopenexr-dev \
        libde265-dev \
        libheif-dev \
        libgl1 \
        libraw20 \
        libraw-dev \
        libraw-bin \
        libltdl-dev \
        libpoppler-glib-dev \
        liborc-0.4-dev \
        libcups2 \
        fftw3-dev \
        locales \
        ffmpeg \
        pngquant \
        mariadb-client \
        unzip \
        cron \
        vim \
        supervisor \
    && mkdir /var/log/supervisord /var/run/supervisord \
    && docker-php-ext-configure zip \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-configure ldap \
    && docker-php-ext-install -j$(nproc) pdo_mysql exif zip gd opcache ldap \
    && a2enmod rewrite \
# Install ionCube \
    && echo [Install ionCube] \
    && curl -o /tmp/ioncube.zip -L https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.zip \
    && PHP_EXT_DIR=$(php-config --extension-dir) \
    && unzip -j /tmp/ioncube.zip ioncube/ioncube_loader_lin_7.4.so -d $PHP_EXT_DIR \
    && echo "zend_extension=ioncube_loader_lin_7.4.so" >> /usr/local/etc/php/conf.d/00_ioncube_loader_lin_7.4.ini \
# Install vips
    && echo [Install vips ${LIBVIPS_VERSION}] \
    && curl -o /tmp/vips.tar.gz -L https://github.com/libvips/libvips/releases/download/v${LIBVIPS_VERSION}/vips-${LIBVIPS_VERSION}.tar.gz \
    && tar zvxf /tmp/vips.tar.gz -C /tmp \
    && cd /tmp/vips-${LIBVIPS_VERSION} \
    && ./configure --enable-debug=no --without-python $1 \
    && make && make install \
    && ldconfig \
# Install ImageMagick
    && echo [Install ImageMagick] \
    && curl -o /tmp/im.tar.gz -L https://download.imagemagick.org/ImageMagick/download/ImageMagick.tar.gz \
    && tar zvxf /tmp/im.tar.gz -C /tmp \
    && cd /tmp/ImageMagick* \
    && ./configure --with-modules \
    && make && make install \
    && ldconfig /usr/local/lib \
# Install STL-THUMB
    && echo [Install STL-THUMB] \
    && curl -o /tmp/stl-thumb.deb -L https://github.com/unlimitedbacon/stl-thumb/releases/download/v0.3.1/stl-thumb_0.3.1_amd64.deb \
    && dpkg -i /tmp/stl-thumb.deb \
# Install LibreOffice
    && echo [Install LibreOffice ${LIBREOFFICE_VERSION}] \
    && curl -o /tmp/lo.tar.gz -L https://download.documentfoundation.org/libreoffice/stable/${LIBREOFFICE_VERSION}/deb/x86_64/LibreOffice_${LIBREOFFICE_VERSION}_Linux_x86-64_deb.tar.gz \
    && tar xvfz /tmp/lo.tar.gz -C /tmp \
    && dpkg -i /tmp/LibreOffice_*/DEBS/*.deb \
# Enable Apache XSendfile
    && echo [Enable Apache XSendfile] \
    && echo "XSendFile On\nXSendFilePath /user-files" | tee "/etc/apache2/conf-available/filerun.conf" \
    && a2enconf filerun \
#Cleanup \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
# Download FileRun installation package
    && echo [Download FileRun installation package version 2021.12.07] \
    && curl -o /filerun.zip -L 'https://f.afian.se/wl/?id=6QUVsGiFM4M5d4RTZlzhpJLehdqMsbKv&fmode=download&recipient=ZmlsZXJ1bi5jb20%3D' \
    && chown www-data:www-data /user-files \
    && chmod +x /wait-for-it.sh /import-db.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/supervisord.conf"]
