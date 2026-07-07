ARG VERSION
FROM python:3.12-slim

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ENV HOME=/config \
    GRID_HOME=/config/.grid \
    GRID_NAME=home \
    GRID_PORT=8090 \
    GRID_HOST=0.0.0.0

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install the grid wheel from the GitHub release
RUN pip install --no-cache-dir \
    "https://github.com/autonomous-ai/autonomous-grid/releases/download/v${VERSION}/grid-${VERSION}-py3-none-any.whl"

COPY entrypoint.sh /app/entrypoint.sh

# Create non-root user
RUN groupadd -g 1000 grid && \
    useradd -u 1000 -g 1000 -d /config -s /bin/sh grid && \
    mkdir -p /config/.grid && \
    chown -R 1000:1000 /config

USER 1000

EXPOSE 8090

LABEL org.opencontainers.image.source="https://github.com/autonomous-ai/autonomous-grid"

ENTRYPOINT ["/app/entrypoint.sh"]
