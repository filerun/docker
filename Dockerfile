FROM php:8.1.23-apache-bullseye
ENV FR_DB_HOST=db \
	FR_DB_PORT=3306 \
	FR_DB_NAME=filerun \
	FR_DB_USER=filerun \
	FR_DB_PASS=filerun \
	APACHE_RUN_USER=user \
	APACHE_RUN_USER_ID=1000 \
	APACHE_RUN_GROUP=user \
	APACHE_RUN_GROUP_ID=1000 \
	LIBVIPS_VERSION="8.14.4" \
	LIBREOFFICE_VERSION="7.5.5" \
	PHP_VERSION_SHORT="8.1"
VOLUME ["/var/www/html", "/user-files"]
COPY ./filerun /filerun
RUN apt-get update  \
    && apt-get install -y --no-install-recommends \
		libfreetype6-dev \
#image formats \
		libjpeg62-turbo-dev \
        libopenjp2-7-dev \
		libtiff-dev \
		libtiff5-dev \
		libwebp-dev \
        libheif-dev \
		libgif-dev \
        libpng-dev \
		librsvg2-dev \
		libraw-dev \
		libraw-bin \
        libde265-dev \
#other \
		libexif-dev \
		libgl1 \
		libltdl-dev \
		libcups2 \
##libvips \
		libgsf-1-dev \
		glib2.0-dev \
		libexpat1-dev \
		libfftw3-dev \
		libimagequant-dev \
        liblcms2-dev \
        libopenjp2-7-dev \
        liborc-0.4-dev \
        librsvg2-dev \
        libopenexr-dev \
        libpoppler-glib-dev \
#other \
        libapache2-mod-xsendfile \
        libldap2-dev \
		libzip-dev \
		libcurl4-gnutls-dev \
		libosmesa6-dev \
		ghostscript \
		locales \
		ffmpeg \
		pngquant \
		mariadb-client \
		unzip \
		cron \
		locales \
		vim \
		supervisor \
	&& mkdir /var/log/supervisord /var/run/supervisord \
	&& docker-php-ext-configure zip \
	&& docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ --with-webp \
	&& docker-php-ext-configure ldap \
	&& docker-php-ext-install -j$(nproc) pdo_mysql exif zip gd opcache ldap \
	&& a2enmod rewrite \
# Install ionCube
    && echo [Install ionCube] \
	&& curl -o /tmp/ioncube.zip -L https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.zip \
	&& PHP_EXT_DIR=$(php-config --extension-dir) \
	&& unzip -j /tmp/ioncube.zip ioncube/ioncube_loader_lin_${PHP_VERSION_SHORT}.so -d $PHP_EXT_DIR \
	&& echo "zend_extension=ioncube_loader_lin_${PHP_VERSION_SHORT}.so" >> /usr/local/etc/php/conf.d/00_ioncube_loader_lin_${PHP_VERSION_SHORT}.ini \
	&& rm -rf /tmp/ioncube \
# Install STL-THUMB
    && echo [Install STL-THUMB] \
    && curl -o /tmp/stl-thumb.deb -L https://github.com/unlimitedbacon/stl-thumb/releases/download/v0.4.0/stl-thumb_0.4.0_amd64.deb \
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
# Install ImageMagick from source
    && echo [Install ImageMagick] \
	&& curl -o /tmp/im.tar.gz -L https://download.imagemagick.org/ImageMagick/download/ImageMagick.tar.gz \
	&& tar -zxf /tmp/im.tar.gz -C /tmp \
    && cd /tmp/ImageMagick* \
    && ./configure --with-modules --with-gslib --without-magick-plus-plus --without-perl --without-x --disable-docs --disable-static \
    && make && make install \
	&& ldconfig /usr/local/lib \
# Install vips from source
    && echo [Install vips ${LIBVIPS_VERSION}] \
	&& curl -o /tmp/vips.tar.gz -L https://github.com/libvips/libvips/releases/download/v${LIBVIPS_VERSION}/vips-${LIBVIPS_VERSION}.tar.gz \
	&& tar -zxf /tmp/vips.tar.gz -C /tmp \
    && cd /tmp/vips-${LIBVIPS_VERSION} \
    && ./configure \
    && make && make install \
	&& ldconfig \
#Cleanup \
    && docker-php-source delete \
    && apt-get clean \
    && rm -rf /tmp/* \
	&& rm -rf /var/lib/apt/lists/* \
#FileRun optimizations
	&& mv /filerun/filerun-optimization.ini /usr/local/etc/php/conf.d/ \
	&& mkdir -p /user-files \
	&& chown www-data:www-data /user-files \
	&& chmod +x /filerun/entrypoint.sh
ENTRYPOINT ["/filerun/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/filerun/supervisord.conf"]