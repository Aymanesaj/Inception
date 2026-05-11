FROM debian:stable-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
	mariadb-server mariadb-client \
	&& rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /

RUN chmod +x /entrypoint.sh

EXPOSE 3306

ENTRYPOINT [ "/entrypoint.sh" ]