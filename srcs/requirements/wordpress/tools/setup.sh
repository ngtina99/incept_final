#!/bin/bash
set -e

echo "[1/4] Waiting for MariaDB to be ready..."

# Wait until MySQL responds
while ! mysqladmin ping -h"$HOST" --silent; do
  sleep 1
done

echo "[2/4] Downloading WordPress..."

cd /var/www/html

# Download only if not already downloaded
if [ ! -f "wp-load.php" ]; then
  wp core download --allow-root
fi

echo "[3/4] Creating wp-config.php..."

# Create wp-config.php only if it doesn't exist
if [ ! -f "wp-config.php" ]; then
  wp config create \
    --dbname="$DATABASE" \
    --dbuser="$DB_USER" \
    --dbpass="$(cat /run/secrets/db_user_password)" \
    --dbhost="$HOST" \
    --allow-root
fi

echo "[4/4] Installing WordPress..."

# Install WordPress only if not already installed
if ! wp core is-installed --allow-root; then
  wp core install \
    --url="https://$DOMAIN_NAME" \
    --title="$WP_TITLE" \
    --admin_user="$WP_ADMIN" \
    --admin_password="$(cat /run/secrets/wp_admin_password)" \
    --admin_email="$WP_ADMIN_EMAIL" \
    --allow-root
  
  wp user create "$WP_USER" "$WP_USER_EMAIL" \
    --user_pass="$(cat /run/secrets/wp_user_password)" \
    --role=author \
    --allow-root
fi

 wp user update "$WP_ADMIN" --user_pass="$(cat /run/secrets/wp_admin_password)" --allow-root
 wp user update "$WP_USER" --user_pass="$(cat /run/secrets/wp_user_password)" --allow-root


echo "✅ WordPress is installed at https://$DOMAIN_NAME"

exec php-fpm7.4 -F
