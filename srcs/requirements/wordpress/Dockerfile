FROM debian:bullseye

RUN apt-get update && apt-get install --no-install-recommends -y \
    php7.4-fpm php-mysql php-redis php-mbstring curl \
	php-zip php-curl php-xml php-gd ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

RUN chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

RUN mkdir -p /var/www/html

RUN mkdir -p /run/php

COPY entrypoint.sh /

RUN chmod +x /entrypoint.sh

EXPOSE 9000

WORKDIR /var/www/html

ENTRYPOINT ["/entrypoint.sh"]