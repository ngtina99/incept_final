FROM debian:bullseye

# Install dependencies
RUN apt-get update && apt-get install -y \
    php php-mysql php-fpm php-curl php-gd php-mbstring php-xml php-xmlrpc \
    mariadb-client wget curl unzip less vim \
    && rm -rf /var/lib/apt/lists/*

# Install wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

# Copy setup.sh inside container
COPY tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

RUN mkdir -p /run/php

ENTRYPOINT ["/setup.sh"]
