DOCKER_COMPOSE = docker compose

build:
	$(DOCKER_COMPOSE) build

up:
	$(DOCKER_COMPOSE) up

re: clean
	$(DOCKER_COMPOSE) down -v && $(DOCKER_COMPOSE) build --no-cache && $(DOCKER_COMPOSE) up

fre: fclean
	$(DOCKER_COMPOSE) down -v && $(DOCKER_COMPOSE) build --no-cache && $(DOCKER_COMPOSE) up

down:
	$(DOCKER_COMPOSE) down

clean:
	$(DOCKER_COMPOSE) down -v
	docker volume prune -f

fclean: clean
	docker system prune -af --volumes

.PHONY: build up re fre down clean fclean