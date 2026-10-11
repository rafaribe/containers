ARG VERSION
FROM node:24-slim

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

WORKDIR /app

RUN npm install -g docmost-mcp@${VERSION} && npm cache clean --force

ENV NODE_ENV=production

LABEL org.opencontainers.image.source="https://github.com/MrMartiniMo/docmost-mcp"

CMD ["docmost-mcp"]
