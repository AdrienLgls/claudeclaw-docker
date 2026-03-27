#!/bin/bash
# Supprime les sessions orphelines qui déclenchent des erreurs claude-mem au démarrage
rm -f /workspace/.claude/claudeclaw/session.json
rm -f /workspace/.claude/claudeclaw/session_1.backup

exec bun run /opt/claudeclaw/src/index.ts start
