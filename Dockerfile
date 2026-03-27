FROM oven/bun:1.3.10-slim

# Install Node.js (required for @anthropic-ai/claude-code)
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

# Créer un utilisateur non-root (Claude Code refuse root avec --dangerously-skip-permissions)
RUN useradd -m -u 1001 -s /bin/bash claudeclaw
USER claudeclaw
ENV HOME=/home/claudeclaw

WORKDIR /workspace

CMD ["bun", "run", "/opt/claudeclaw/src/index.ts", "start"]
