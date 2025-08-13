#!/bin/bash
set -e

# exit immediately if any command returns a non-zero/error status
# run in lightweight shell 

# set up variables
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
DB_USER="${DB_USER}"
DB_PASSWORD=$(cat /run/secrets/db_user_password)
DB_NAME="${DATABASE}"

# MariaDB/MySQL default, systemuser, location data dir
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --ldata=/var/lib/mysql
fi

# start MariaDB, any interface can connect
mysqld_safe --bind-address=0.0.0.0 &
pid="$!"

# we only start to fill it if MYSQL is ready
until mysqladmin ping --silent; do
    sleep 1
done

# setup data tables and reload
if [ ! -f "/var/lib/mysql/.db_initialized" ]; then
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}'; FLUSH PRIVILEGES;"

    mysql -u root -p"${DB_ROOT_PASSWORD}" <<-EOSQL
        CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
        CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
        GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
        FLUSH PRIVILEGES;
EOSQL

    touch /var/lib/mysql/.db_initialized
fi


#keep it running
wait "$pid"
