all: up

up:
	docker compose -f ./srcs/compose.yaml up -d
start:
	docker compose -f ./srcs/compose.yaml start
stop:
	docker compose -f ./srcs/compose.yaml stop
down:
	docker compose -f ./srcs/compose.yaml down
build:
	docker compose -f ./srcs/compose.yaml build

clean: down
	docker image rmi $$(docker images -q)
	docker volume rm $$(docker volume ls -q)

re: down up