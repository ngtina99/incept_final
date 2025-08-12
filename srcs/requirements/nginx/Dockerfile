FROM debian:bullseye

# Linux based image

# No interactive prompts (Configure a package now?)
ENV DEBIAN_FRONTEND=noninteractive

# Install packages: download latest, (-y=yes), webserver, self-signed TLS (Transport Layer Security) certification, no need for that containers after installing
RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# directory (-p=parent) for site
RUN mkdir -p /var/www/html

# copy NGINX config, cert generation scripts -> from local folder put it into the image
COPY conf/default.conf /etc/nginx/sites-available/default
COPY tools/setup.sh /setup.sh
COPY tools/ssl.sh /ssl.sh

# make script executable
RUN chmod +x /setup.sh /ssl.sh

# expose HTTPS port, listens on port 443 (HTTPS)
EXPOSE 443

# run  setup script on container start, it calls mkcert.sh to generate the certificate before starting nginx
ENTRYPOINT ["/setup.sh"]