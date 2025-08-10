FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y php php-fpm php-mysqli nginx wget && \
    mkdir -p /var/www/html

# Download Adminer (latest stable)
RUN wget "https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php" -O /var/www/html/index.php

# Nginx config
COPY default.conf /etc/nginx/sites-available/default

EXPOSE 8081

CMD service php7.4-fpm start && nginx -g 'daemon off;'