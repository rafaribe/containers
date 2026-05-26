ARG VERSION
FROM node:22-slim

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 --branch v${VERSION} https://github.com/MrMartiniMo/docmost-mcp.git /tmp/docmost-mcp && \
    cp -r /tmp/docmost-mcp/* /app/ && \
    rm -rf /tmp/docmost-mcp

RUN npm ci && \
    npm run build && \
    npm prune --production && \
    npm cache clean --force

ENV NODE_ENV=production

LABEL org.opencontainers.image.source="https://github.com/MrMartiniMo/docmost-mcp"

CMD ["node", "build/index.js"]
