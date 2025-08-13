NAME           = inception
COMMAND        = docker compose
FILE           = srcs/docker-compose.yml
USER           = thuy-ngu
SECRETS_DIR    = ./secrets
SECRETS        = db_root_password db_user_password wp_admin_password wp_user_password

all: up
	@echo "$(NAME) is up and running!"

up: folder password
	$(COMMAND) -f $(FILE) up -d --build
	@echo "Containers started"

folder:
	@mkdir -p /home/$(USER)/data/mariadb
	@mkdir -p /home/$(USER)/data/wordpress
	@echo "📂 Data folders prepared in /home/$(USER)/data"

password:
	@mkdir -p $(SECRETS_DIR)
	@for f in $(SECRETS); do \
		openssl rand -base64 8 > "$(SECRETS_DIR)/$$f"; \
	done
	@echo "🔒 Secrets stored in $(SECRETS_DIR)."

down:
	$(COMMAND) -f $(FILE) down
	@echo "Containers stopped"

clean:
	$(COMMAND) -f $(FILE) down --volumes
	@echo "Removed: containers and volumes removed"

fclean:
	$(COMMAND) -f $(FILE) down --volumes --rmi all
	docker volume prune -f
	docker image prune -a -f
	sudo rm -rf /home/$(USER)/data/mariadb /home/$(USER)/data/wordpress
	rm -f $(SECRETS_DIR)/*
	@echo " Removed> containers, volumes, unused images, project data, and secrets"

logs:
	$(COMMAND) -f $(FILE) logs -f

re: fclean all

.PHONY: all up down clean fclean re logs folder password
