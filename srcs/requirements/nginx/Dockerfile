FROM debian:stable-slim

RUN apt-get update && \
    apt-get install -y nginx openssl && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl

COPY conf/nginx.conf /etc/nginx/nginx.conf

COPY tools/entrypoint.sh /

RUN chmod +x /entrypoint.sh

EXPOSE 443

ENTRYPOINT ["/entrypoint.sh"]