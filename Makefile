NAME=inception
COMPOSE=docker compose
YML=srcs/docker-compose.yml

PC_USER := thuy-ngu
MARIADB_VOLUME_PATH := /home/$(PC_USER)/data/mariadb
WORDPRESS_VOLUME_PATH := /home/$(PC_USER)/data/wordpress

SECRETS_DIR := ./secrets
PASSWORD_LENGTH := 12

gen-secrets:
	@mkdir -p $(SECRETS_DIR)
	@for file in ftp_password mysql_root_password mysql_user_password wp_admin_password wp_user_password; do \
		if [ ! -s $(SECRETS_DIR)/$$file ]; then \
			echo "Generating $$file..."; \
			openssl rand -base64 $(PASSWORD_LENGTH) > $(SECRETS_DIR)/$$file; \
		else \
			echo "$$file already exists, skipping"; \
		fi \
	done
	@echo "Secrets generated in $(SECRETS_DIR)."

makedirs:
	mkdir -p $(MARIADB_VOLUME_PATH)
	mkdir -p $(WORDPRESS_VOLUME_PATH)

all: up

up: makedirs gen-secrets
	$(COMPOSE) -f $(YML) up -d --build

down:
	$(COMPOSE) -f $(YML) down

clean:
	$(COMPOSE) -f $(YML) down --volumes

fullclean:
	$(COMPOSE) -f $(YML) down --volumes --rmi all
	sudo rm -rf $(MARIADB_VOLUME_PATH) $(WORDPRESS_VOLUME_PATH)
	docker volume prune -f
	docker image prune -a -f
	sudo rm -rf $(MARIADB_VOLUME_PATH) $(WORDPRESS_VOLUME_PATH)
	rm -f $(SECRETS_DIR)/*
	@echo "Secrets removed from $(SECRETS_DIR)."

re: fclean all

logs:
	$(COMPOSE) -f $(YML) logs -f

uplogs: up
	$(COMPOSE) -f $(YML) logs -f

.PHONY: up down clean fclean re logs uplogs fullclean makedirs
