FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y nginx && \
    rm -rf /var/lib/apt/lists/*

COPY nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /var/www/html

COPY index.html /var/www/html/index.html

ENTRYPOINT ["nginx", "-g", "daemon off;"]

EXPOSE 80