ARG VERSION
FROM node:26-alpine

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

WORKDIR /app

# Install git and iputils (for ping/ARP scanning capability)
RUN apk add --no-cache \
    git \
    iputils

# Clone Bingfox source
RUN git clone --depth 1 https://github.com/Radiotechniman/Bingfox.git .

# Install server production dependencies
RUN npm install --omit=dev --no-audit --no-fund && \
    npm cache clean --force

# Build the frontend
RUN cd frontend && \
    npm install --no-audit --no-fund && \
    npm run build && \
    npm cache clean --force

# Create persistent data directory and symlink db into it
RUN mkdir -p /app/data && \
    ln -sf /app/data/data.db /app/data.db && \
    chown -R 1000:1000 /app

USER 1000:1000

EXPOSE 3001

LABEL org.opencontainers.image.source="https://github.com/rafaribe/containers"
LABEL org.opencontainers.image.upstream="https://github.com/Radiotechniman/Bingfox"

CMD ["node", "server.js"]

