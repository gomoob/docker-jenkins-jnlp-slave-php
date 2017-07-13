FROM jenkinsci/jnlp-slave:latest
MAINTAINER Baptiste Gaillard <baptiste.gaillard@gomoob.com>

# see https://github.com/phpbrew/phpbrew-container
USER root

# Install utility libraries and tools
RUN apt-get update \
 && apt-get install -y gcc g++ make automake libxml2 libxml2-dev libxml2-utils libssl-dev lcov systemtap-sdt-dev \
                       libbz2-dev libgmp-dev libgmp3-dev libicu-dev libmcrypt-dev libreadline-dev libxslt1-dev

# Install PHP (required by phpbrew)
RUN echo "deb http://packages.dotdeb.org jessie all" > /etc/apt/sources.list.d/dotdeb.list \
    && wget -O- https://www.dotdeb.org/dotdeb.gpg | apt-key add - \
    && apt update

RUN apt install -y php7.0 php7.0-fpm php7.0-mysql php7.0-curl php7.0-json php7.0-gd php7.0-mcrypt php7.0-msgpack \
                   php7.0-memcached php7.0-intl php7.0-sqlite3 php7.0-gmp php7.0-geoip php7.0-mbstring php7.0-xml \
                   php7.0-zip

# Install php tools
RUN mkdir -p /usr/bin \
  && wget -q -O /usr/bin/phpunit https://phar.phpunit.de/phpunit.phar && chmod +x /usr/bin/phpunit \
  && wget -q -O /usr/bin/composer https://getcomposer.org/composer.phar && chmod +x /usr/bin/composer \
  && wget -q -O /usr/bin/phpmd http://static.phpmd.org/php/latest/phpmd.phar && chmod +x /usr/bin/phpmd \
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
RUN phpbrew init \
  && echo 'source $HOME/.phpbrew/bashrc' >> /home/jenkins/.bashrc \
  && /bin/bash -c "source /home/jenkins/.phpbrew/bashrc"

# Install several PHP versions
RUN phpbrew install -j $(nproc) 7.0.21 +default \
 && phpbrew install -j $(nproc) 7.1.7 +default

# Create aliases to call PHP more easyly
RUN alias php-7.0="php-7.0.21" \
 && alias php-7.1="php-7.1.7"
