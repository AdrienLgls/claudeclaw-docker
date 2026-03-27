.PHONY: fix up down restart rebuild logs ps

# Corrige les permissions après toute modification depuis root
fix:
	chown -R 1001:1001 ./bots/

# Démarre tous les bots
up: fix
	docker compose up -d

# Arrête tous les bots
down:
	docker compose down

# Redémarre un ou tous les bots  (make restart BOT=mathis)
restart: fix
	docker compose restart $(BOT)

# Rebuild l'image + redémarre (après modif Dockerfile ou claudeclaw-config)
rebuild: fix
	docker compose build && docker compose up -d --force-recreate

# Logs en live (make logs BOT=mathis)
logs:
	docker compose logs -f $(BOT)

# État des containers
ps:
	docker compose ps
