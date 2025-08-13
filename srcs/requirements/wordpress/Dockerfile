FROM debian:bullseye
# Linux based (broader package) image

# install packages: download latest (-y=yes), FastCGI Process Manager (FPM), curl->fetch updates, gd (image), php-mbstring (multibyte string-non latin), no need for that containers after installing
RUN apt-get update && apt-get install -y \
    php php-mysql php-fpm php-curl php-gd php-mbstring php-xml php-xmlrpc \
    mariadb-client wget curl unzip less vim \
    && rm -rf /var/lib/apt/lists/*

# download and run WP-CLI, command-line tool to manage WordPress
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

#copy setup
COPY tools/setup.sh /setup.sh

# make executable
RUN chmod +x /setup.sh

# directory (-p=parent) runtime php
RUN mkdir -p /run/php

# expose port
EXPOSE 3306

# run  setup script on container start
ENTRYPOINT ["/setup.sh"]
