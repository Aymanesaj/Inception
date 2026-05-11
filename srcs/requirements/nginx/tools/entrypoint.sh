#!/bin/sh

if [ ! -f /etc/nginx/ssl/server.crt ] || [ ! -f /etc/nginx/ssl/server.key ]; then
  echo "Generating self-signed certificate..."
  openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/server.key \
    -out /etc/nginx/ssl/server.crt \
    -subj "/C=US/ST=NA/L=NA/O=Local/OU=Dev/CN=localhost"
fi

nginx -t || exit 1
exec nginx -g "daemon off;"