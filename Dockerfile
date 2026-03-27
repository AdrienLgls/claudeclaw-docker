FROM oven/bun:1.3.10-slim

# Install Node.js + git + python3
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y curl ca-certificates git python3 && \
    curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Claude Code CLI
RUN npm install -g @anthropic-ai/claude-code

# Copy ClaudeClaw plugin source + install deps
COPY claudeclaw-src/ /opt/claudeclaw/
RUN cd /opt/claudeclaw && bun install --frozen-lockfile

# Clone claudeclaw-config
RUN git clone https://github.com/AdrienLgls/claudeclaw-config.git /opt/claudeclaw-config

# Créer un utilisateur non-root (Claude Code refuse root avec --dangerously-skip-permissions)
RUN useradd -m -u 1001 -s /bin/bash claudeclaw && \
    chown -R claudeclaw:claudeclaw /opt/claudeclaw-config

USER claudeclaw
ENV HOME=/home/claudeclaw

# Installer la config (skills, commands, agents, hooks) dans $HOME/.claude/
RUN bash /opt/claudeclaw-config/install.sh /home/claudeclaw/.claude

WORKDIR /workspace

COPY --chown=claudeclaw:claudeclaw entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
