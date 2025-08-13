#!/bin/bash
set -e

# exit immediately if any command returns a non-zero/error status
# run in lightweight shell 


ts() { date '+%H:%M:%S'; }
info() { echo "[$(ts)] ➤ $*"; }
step() { echo; echo "[$(ts)] === $* ==="; }
ok()  { echo "[$(ts)] ✅ $*"; }

step "Waiting for MariaDB at \"$HOST\" to be ready"
while ! mysqladmin ping -h"$HOST" --silent; do
  sleep 1
done
ok "MariaDB is reachable"

step "Ensuring WordPress core is present"
cd /var/www/html
if [ ! -f "wp-load.php" ]; then
  wp core download --allow-root
fi
ok "Core files ready"

step "Creating wp-config.php if missing"
if [ ! -f "wp-config.php" ]; then
  info "Generating wp-config.php with DB settings"
  wp config create \
    --dbname="$DATABASE" \
    --dbuser="$DB_USER" \
    --dbpass="$(cat /run/secrets/db_user_password)" \
    --dbhost="$HOST" \
    --allow-root
fi
ok "Config ready"

step "Installing WordPress if not installed"
if ! wp core is-installed --allow-root; then
  info "Running initial wp install"
  wp core install \
    --url="https://$DOMAIN_NAME" \
    --title="$WP_TITLE" \
    --admin_user="$WP_ADMIN" \
    --admin_password="$(cat /run/secrets/wp_admin_password)" \
    --admin_email="$WP_ADMIN_EMAIL" \
    --allow-root

  info "Creating regular user \"$WP_USER\""
  wp user create "$WP_USER" "$WP_USER_EMAIL" \
    --user_pass="$(cat /run/secrets/wp_user_password)" \
    --role=author \
    --allow-root
fi

info "Making sure admin and user passwords are up to date"
 wp user update "$WP_ADMIN" --user_pass="$(cat /run/secrets/wp_admin_password)" --allow-root
 wp user update "$WP_USER" --user_pass="$(cat /run/secrets/wp_user_password)" --allow-root

ok "User credentials synced"
ok "WordPress ready at https://$DOMAIN_NAME"

# run PHP-FPM, main process, foreground connects to terminal
exec php-fpm7.4 -F
