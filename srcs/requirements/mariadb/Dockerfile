FROM debian:bullseye
# Linux based (broader package) image

# Install packages: download latest, (-y=yes), webserver, self-signed TLS (Transport Layer Security) certification, no need for that containers after installing
RUN apt-get update && \
    apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*


COPY tools/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

# expose port
EXPOSE 3306

# run  setup script on container start
ENTRYPOINT ["/entrypoint.sh"]
