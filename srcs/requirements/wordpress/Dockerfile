FROM debian:bookworm

RUN apt-get update && apt-get install --no-install-recommends -y \
    php8.2-fpm php8.2-mysql php8.2-redis php8.2-mbstring php8.2-zip \
    php8.2-curl php8.2-xml php8.2-gd curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

RUN mkdir -p /var/www/html /run/php

COPY entrypoint.sh /

RUN chmod +x /entrypoint.sh

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["/entrypoint.sh"]
