FROM debian:bullseye

# Avoids interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install Nginx and OpenSSL
RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Copy config and script
COPY conf/default.conf /etc/nginx/sites-available/default
COPY tools/ssl.sh /ssl.sh

# Make script executable
RUN chmod +x /ssl.sh && /ssl.sh

# Create directory for site
RUN mkdir -p /var/www/html

EXPOSE 443

# Run nginx in foreground to keep the container alive.
# "-g" passes the "daemon off;" directive directly to nginx.
CMD ["nginx", "-g", "daemon off;"]
