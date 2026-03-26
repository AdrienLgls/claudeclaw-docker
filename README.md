# ClaudeClaw Docker

## Structure

```
docker/
├── Dockerfile                  # Image de base (Bun + Node + Claude Code + ClaudeClaw)
├── docker-compose.yml          # Services (un par bot Discord)
├── .env                        # CLAUDE_CODE_OAUTH_TOKEN (ne pas committer)
├── claudeclaw-src/             # Copie du plugin ClaudeClaw (voir setup)
└── bots/
    ├── mathis/
    │   ├── workspace/          # CLAUDE.md, todo, etc.
    │   └── claude-state/       # .claude/ du bot (Discord token, sessions, logs)
    └── mathys/
        ├── workspace/
        └── claude-state/
```

## Setup initial

### 1. Remplir le token dans .env
```bash
cat /home/claudeclaw/.secrets  # copier le token ici
```

### 2. Copier le plugin ClaudeClaw
```bash
cp -r /home/claudeclaw/.claude/plugins/marketplaces/claudeclaw ./claudeclaw-src
```

### 3. Copier l'état existant des bots (préserve Discord token, whisper, sessions)
```bash
cp -r /home/claudeclaw/bots/mathis/.claude ./bots/mathis/claude-state
cp -r /home/claudeclaw/bots/mathys/.claude ./bots/mathys/claude-state
cp /home/claudeclaw/bots/mathis/CLAUDE.md ./bots/mathis/workspace/CLAUDE.md
cp /home/claudeclaw/bots/mathys/CLAUDE.md ./bots/mathys/workspace/CLAUDE.md
```

### 4. Build et démarrage
```bash
docker compose build
docker compose up -d
docker compose logs -f
```

## Ajouter un nouveau bot

1. Créer la structure :
```bash
mkdir -p bots/nouveau-bot/workspace bots/nouveau-bot/claude-state
```

2. Configurer le bot (CLAUDE.md + settings claudeclaw avec le token Discord)

3. Ajouter le service dans docker-compose.yml

4. `docker compose up -d nouveau-bot`

## Commandes utiles
```bash
docker compose ps                        # état des bots
docker compose logs -f mathis            # logs d'un bot
docker compose restart mathis            # redémarrer un bot
docker compose stop && docker compose up -d  # redémarrer tout
```
