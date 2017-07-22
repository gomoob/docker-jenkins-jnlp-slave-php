FROM jenkinsci/jnlp-slave:latest
MAINTAINER Baptiste Gaillard <baptiste.gaillard@gomoob.com>

# see https://github.com/phpbrew/phpbrew-container
USER root

# Install utility libraries and tools
RUN apt-get update \
 && apt-get install -y apt-utils gcc g++ make automake libxml2 libxml2-dev libxml2-utils libssl-dev lcov \
                       systemtap-sdt-dev libbz2-dev libgmp-dev libgmp3-dev libicu-dev libmcrypt-dev libreadline-dev \
                       libxslt1-dev openssl libssl-dev libcurl4-openssl-dev libcurl4-openssl-dev pkg-config \
                       libsasl2-dev postgresql-server-dev-all libjpeg-dev libpng12-dev mediainfo

# Install PHP (required by phpbrew)
RUN echo "deb http://packages.dotdeb.org jessie all" > /etc/apt/sources.list.d/dotdeb.list \
    && wget -O- https://www.dotdeb.org/dotdeb.gpg | apt-key add - \
    && apt update

RUN apt install -y php7.0 php7.0-dev php7.0-fpm php7.0-mysql php7.0-curl php7.0-json php7.0-gd php7.0-mcrypt \
 php7.0-msgpack php7.0-memcached php7.0-intl php7.0-sqlite3 php7.0-gmp php7.0-geoip php7.0-mbstring php7.0-xml \
 php7.0-zip

# Install php tools
ENV COMPOSER_VERSION 1.4.2
ENV PHPMD_VERSION 2.6.0
ENV PHPUNIT_VERSION 6.2.3

RUN mkdir -p /usr/bin \
  && wget -q -O /usr/bin/phpunit https://phar.phpunit.de/phpunit-$PHPUNIT_VERSION.phar && chmod +x /usr/bin/phpunit \
  && wget -q -O /usr/bin/composer https://getcomposer.org/download/$COMPOSER_VERSION/composer.phar && chmod +x /usr/bin/composer \
  && wget -q -O /usr/bin/phpmd http://static.phpmd.org/php/$PHPMD_VERSION/phpmd.phar && chmod +x /usr/bin/phpmd \
  && wget -q -O /usr/bin/sami http://get.sensiolabs.org/sami.phar && chmod +x /usr/bin/sami \
  && wget -q -O /usr/bin/phpcov https://phar.phpunit.de/phpcov.phar && chmod +x /usr/bin/phpcov \
  && wget -q -O /usr/bin/phpcpd https://phar.phpunit.de/phpcpd.phar && chmod +x /usr/bin/phpcpd \
  && wget -q -O /usr/bin/phploc https://phar.phpunit.de/phploc.phar && chmod +x /usr/bin/phploc \
  && wget -q -O /usr/bin/phptok https://phar.phpunit.de/phptok.phar && chmod +x /usr/bin/phptok \
  && wget -q -O /usr/bin/box https://github.com/box-project/box2/releases/download/2.5.2/box-2.5.2.phar && chmod +x /usr/bin/box

# Install phpbrew
RUN curl -L -O https://github.com/phpbrew/phpbrew/raw/master/phpbrew \
    && chmod +x phpbrew \
    && mv phpbrew /usr/bin

# Install Node
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - \
 && apt-get install -y nodejs

# Install Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
 && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
 && apt-get update && apt-get install -y yarn

# Install Grunt
RUN npm install -g grunt-cli

USER jenkins

# Install prestissimo to speedup composer installs
RUN composer global require hirak/prestissimo

# Configure phpbrew
ENV PHPBREW_ROOT /home/jenkins/.phpbrew
ENV PHPBREW_HOME /home/jenkins/.phpbrew
ENV PHPBREW_SET_PROMPT 1
ENV PHPBREW_PHP php-7.1.7

# Install several PHP versions
RUN phpbrew init \
 && echo 'source /home/jenkins/.phpbrew/bashrc' >> /home/jenkins/.bashrc \
 && phpbrew install -j $(nproc) 7.0.21 +default +dbs +gd +iconv +intl -- \
 --with-libdir=lib/x86_64-linux-gnu --with-gd=shared --enable-gd-natf --with-jpeg-dir=/usr --with-png-dir=/usr \
 && phpbrew install -j $(nproc) 7.1.7 +default +dbs +gd +iconv +intl -- \
 --with-libdir=lib/x86_64-linux-gnu --with-gd=shared --enable-gd-natf --with-jpeg-dir=/usr --with-png-dir=/usr

# Install several extensions for each PHP version
ENV PHPBREW_PHP php-7.0.21
RUN phpbrew switch 7.0.21 \
 && phpbrew ext install --downloader wget xdebug  latest && phpbrew ext clean xdebug \
 && phpbrew ext install --downloader wget apcu    latest && phpbrew ext clean apcu \
 && phpbrew ext install --downloader wget apcu_bc latest && phpbrew ext clean apcu_bc \
 && phpbrew ext install --downloader wget mongodb latest && phpbrew ext clean mongodb

ENV PHPBREW_PHP php-7.1.7
RUN phpbrew switch 7.1.7 \
 && phpbrew ext install --downloader wget xdebug  latest && phpbrew ext clean xdebug \
 && phpbrew ext install --downloader wget apcu    latest && phpbrew ext clean apcu \
 && phpbrew ext install --downloader wget apcu_bc latest && phpbrew ext clean apcu_bc \
 && phpbrew ext install --downloader wget mongodb latest && phpbrew ext clean mongodb

RUN phpbrew clean php-7.0.21 \
 && phpbrew clean php-7.1.7

# Update PHP ini file names to enforce loading in a specific order
RUN rm $PHPBREW_HOME/php/php-7.0.21/var/db/* \
 && rm $PHPBREW_HOME/php/php-7.1.7/var/db/*

COPY ini/* $PHPBREW_HOME/php/php-7.0.21/var/db/
COPY ini/* $PHPBREW_HOME/php/php-7.1.7/var/db/

USER root
RUN chown jenkins:jenkins $PHPBREW_HOME/php/php-7.0.21/var/db/* \
 && chown jenkins:jenkins $PHPBREW_HOME/php/php-7.1.7/var/db/*
USER jenkins

# For unknown reasons we encounter the following XDebug loading error, so we manually copy the XDebug library
#  "Failed loading /usr/lib/php/20151012/xdebug.so:  /usr/lib/php/20151012/xdebug.so: cannot open shared object file: \
#   No such file or directory"
RUN echo "zend_extension=$PHPBREW_HOME/php/php-7.0.21/lib/php/extensions/no-debug-non-zts-20151012/xdebug.so" \
    > $PHPBREW_HOME/php/php-7.0.21/var/db/10-xdebug.ini \
 && echo "zend_extension=$PHPBREW_HOME/php/php-7.1.7/lib/php/extensions/no-debug-non-zts-20160303/xdebug.so" \
    > $PHPBREW_HOME/php/php-7.1.7/var/db/10-xdebug.ini

# Create aliases to call PHP more easyly
COPY php/php-7.0.21                /usr/bin/php-7.0.21
COPY php/php-7.0.21                /usr/bin/php-7.0
COPY php/php-7.1.7                 /usr/bin/php-7.1.7
COPY php/php-7.1.7                 /usr/bin/php-7.1
COPY php/php-without-xdebug-7.0.21 /usr/bin/php-without-xdebug-7.0.21
COPY php/php-without-xdebug-7.0.21 /usr/bin/php-without-xdebug-7.0
COPY php/php-without-xdebug-7.1.7  /usr/bin/php-without-xdebug-7.1.7
COPY php/php-without-xdebug-7.1.7  /usr/bin/php-without-xdebug-7.1

# The 'php' and 'php-without-xdebug' commands should call the most recent PHP versions
USER root
RUN rm /usr/bin/php \
 && cp /usr/bin/php-7.1.7 /usr/bin/php \
 && cp /usr/bin/php-without-xdebug-7.1.7 /usr/bin/php-without-xdebug \
 && chmod +x /usr/bin/php*
USER jenkins

ENTRYPOINT ["jenkins-slave"]
