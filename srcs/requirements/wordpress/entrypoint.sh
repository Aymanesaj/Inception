#!/bin/bash

set -e

sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php/7.4/fpm/pool.d/www.conf

mkdir -p /run/php
mkdir -p /var/www/html

chown -R www-data:www-data /var/www/html

until mysqladmin ping -h"${WORDPRESS_DB_HOST}" -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" --silent; do
    echo "Waiting for MariaDB..."
    sleep 2
done

if [ ! -f /var/www/html/.wp_installed ]; then
    echo "Setting up WordPress..."

    wp core download \
        --path=/var/www/html \
        --allow-root

    wp config create \
        --path=/var/www/html \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --dbhost="${WORDPRESS_DB_HOST}" \
        --allow-root

    wp core install \
        --path=/var/www/html \
        --url="${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --allow-root

    wp user create \
        "${WP_USER}" \
        "${WP_USER_EMAIL}" \
        --path=/var/www/html \
        --user_pass="${WP_USER_PASSWORD}" \
        --allow-root

    chown -R www-data:www-data /var/www/html
    touch /var/www/html/.wp_installed
    echo "WordPress setup complete."
fi

exec php-fpm7.4 -F