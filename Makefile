all: up

up:
	docker-compose -f ./srcs/docker-compose.yml up -d
start:
	docker-compose -f ./srcs/docker-compose.yml start
stop:
	docker-compose -f ./srcs/docker-compose.yml stop
down:
	docker-compose -f ./srcs/docker-compose.yml down
build:
	docker-compose -f ./srcs/docker-compose.yml build

clean: down
	docker image rmi $$(docker images -q)
	docker volume rm $$(docker volume ls -q)

re: down up