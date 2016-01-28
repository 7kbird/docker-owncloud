FROM php:5.6-apache

RUN apt-get update && apt-get install -y \
	bzip2 \
	libcurl4-openssl-dev \
	libfreetype6-dev \
	libicu-dev \
	libjpeg-dev \
	libmcrypt-dev \
	libmemcached-dev \
	libpng12-dev \
	libpq-dev \
	libxml2-dev \
	sudo \
	unzip

#gpg key from https://owncloud.org/owncloud.asc
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys E3036906AD9F30807351FAC32D5D5E97F6978A26

# https://doc.owncloud.org/server/8.1/admin_manual/installation/source_installation.html#prerequisites
RUN docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd intl mbstring mcrypt mysql opcache pdo_mysql pdo_pgsql pgsql zip

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

# PECL extensions
RUN pecl install APCu-4.0.10 redis memcached \
	&& docker-php-ext-enable apcu redis memcached

RUN a2enmod rewrite

ENV OWNCLOUD_VERSION 8.2.2
ENV OWNCLOUD_ROOT_DIR /var/www/html
ENV OWNCLOUD_STORE_DIR /owncloud_data

RUN filename="owncloud-${OWNCLOUD_VERSION}.tar.bz2" && curl -fsSL -o "${filename}" \
	"https://download.owncloud.org/community/${filename}" \
	&& curl -fsSL -o ${filename}.asc \
		"https://download.owncloud.org/community/${filename}.asc" \
	&& curl https://download.owncloud.org/community/${filename}.md5 | md5sum -c - \
	&& gpg --verify ${filename}.asc \
	&& tar -xjf ${filename} --strip-components=1 -C ${OWNCLOUD_ROOT_DIR} \
	&& rm ${filename} ${filename}.asc \
	&& mv ${OWNCLOUD_ROOT_DIR}/config ${OWNCLOUD_ROOT_DIR}/config_back \
	&& mkdir -p ${OWNCLOUD_ROOT_DIR}/data ${OWNCLOUD_STORE_DIR}/data \
	&& ln -s ${OWNCLOUD_STORE_DIR}/config ${OWNCLOUD_ROOT_DIR}/config \
	&& chown -R www-data /var/www/html ${OWNCLOUD_STORE_DIR}

ENV OWNCLOUD_DATA_DIR ${OWNCLOUD_STORE_DIR}/data
ENV OWNCLOUD_BUILD_DIR /usr/owncloud_build
COPY build ${OWNCLOUD_BUILD_DIR}
COPY docker-entrypoint.sh /entrypoint.sh

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME ${OWNCLOUD_STORE_DIR}

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
