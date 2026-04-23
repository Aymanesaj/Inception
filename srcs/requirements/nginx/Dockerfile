FROM debian:stable-slim

RUN apt-get update && \
    apt-get install -y nginx && \
    rm -rf /var/lib/apt/lists/*

COPY conf/nginx.conf /etc/nginx/

COPY . .

EXPOSE 443

ENTRYPOINT ["sh", "tools/entrypoint.sh"]