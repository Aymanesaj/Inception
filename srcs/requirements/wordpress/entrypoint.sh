#!/bin/bash

set -e

WP_PATH="/var/www/html"

sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php/7.4/fpm/pool.d/www.conf

mkdir -p /run/php
mkdir -p "$WP_PATH"

chown -R www-data:www-data "$WP_PATH"

echo "Starting WordPress initialization..."

if [ ! -f "$WP_PATH/wp-load.php" ]; then
    echo "Downloading WordPress..."
    wp core download \
        --path="$WP_PATH" \
        --allow-root
fi

if [ ! -f "$WP_PATH/wp-config.php" ]; then
    echo "Creating wp-config.php..."
    wp config create \
        --path="$WP_PATH" \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --dbhost="${WORDPRESS_DB_HOST}" \
        --allow-root
fi

if ! wp core is-installed --path="$WP_PATH" --allow-root >/dev/null 2>&1; then
    echo "Installing WordPress..."
    wp core install \
        --path="$WP_PATH" \
        --url="${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --allow-root
fi

if ! wp user get "${WP_USER}" --path="$WP_PATH" --allow-root >/dev/null 2>&1; then
    echo "Creating WordPress user..."
    wp user create \
        "${WP_USER}" \
        "${WP_USER_EMAIL}" \
        --path="$WP_PATH" \
        --user_pass="${WP_USER_PASSWORD}" \
        --allow-root
fi

if ! wp plugin is-installed redis-cache --path="$WP_PATH" --allow-root >/dev/null 2>&1; then
    echo "Installing Redis plugin..."
    wp plugin install redis-cache \
        --activate \
        --path="$WP_PATH" \
        --allow-root
fi

if ! wp config has WP_REDIS_HOST --path="$WP_PATH" --allow-root >/dev/null 2>&1; then
    echo "Configuring Redis..."
    wp config set WP_REDIS_HOST redis \
        --path="$WP_PATH" \
        --allow-root

    wp config set WP_REDIS_PORT 6379 \
        --raw \
        --path="$WP_PATH" \
        --allow-root
fi

if ! wp redis status --path="$WP_PATH" --allow-root >/dev/null 2>&1; then
    echo "Enabling Redis object cache..."
    wp redis enable \
        --path="$WP_PATH" \
        --allow-root
fi

chown -R www-data:www-data "$WP_PATH"

echo "WordPress initialization complete."

exec php-fpm7.4 -F