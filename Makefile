build:
	docker compose build

up:
	docker compose up

re: clean
	docker compose down -v && docker compose build --no-cache && docker compose up

fre: fclean
	docker compose down -v && docker compose build --no-cache && docker compose up

down:
	docker compose down

clean:
	docker compose down -v
	docker volume prune -f

fclean: clean
	docker system prune -af --volumes