FROM debian:9
MAINTAINER Florian Mueller <docker@flmue.de>

# Let the container know that there is no tty
ENV DEBIAN_FRONTEND noninteractive
ENV COMPOSER_NO_INTERACTION 1

# Add Node.js repo
RUN apt-get update \
 && apt-get install --no-install-recommends -y \
 apt-utils \ 
 curl \
 apt-transport-https \
 ca-certificates \
 gnupg2 \
 wget \
 sudo \
 # node 
 && curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - \
 && echo "deb https://deb.nodesource.com/node_6.x jessie main" > /etc/apt/sources.list.d/nodesource.list \
 # yarń
 && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
 && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
 # Install tools
 && apt-get update \
 && apt-get install --no-install-recommends -y \
 openssh-client \
 bzip2 \
 unzip \
 rsync \
 git \
 php-cli \
 php-common \
 php-curl \
 php-gd \
 php-mbstring \ 
 php-mysql \
 php-soap \
 php-xml \
 php-xmlrpc \
 php-xsl \
 php-tidy \
 php-zip \
 php-imagick \
 php-xdebug \
 nodejs \
 yarn \
 ant \
 libfontconfig \
 # Slim down image
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/man/?? /usr/share/man/??_*

# Show versions
RUN php -v
RUN node -v
RUN npm -v
RUN yarn -v

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer selfupdate

# Install node tools
RUN npm install -g grunt
RUN npm install -g grunt-cli
RUN grunt --version

# Set the Docker host, because we're assuming we're using docker in docker.
ENV DOCKER_HOST "tcp://docker:2375"

# Expose Docker socket for Docker-in-Docker
VOLUME /var/run/docker.sock
