ARG VERSION
FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

RUN apt-get update && \
    apt-get install -y --no-install-recommends git && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd --system --gid 1000 mcp \
    && useradd --system --gid 1000 --uid 1000 --create-home mcp

WORKDIR /app

ENV UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy \
    PATH="/app/.venv/bin:$PATH"

RUN git clone --branch update-api-implementation --single-branch https://github.com/gloos/mealie-mcp-server.git /app && \
    uv sync --locked && \
    uv add fastmcp httpx && \
    chown -R 1000:1000 /app

COPY apps/mealie-mcp-server/server.py /app/src/server.py

RUN chown 1000:1000 /app/src/server.py

LABEL org.opencontainers.image.source="https://github.com/rafaribe/containers"

USER 1000:1000

ENTRYPOINT ["fastmcp", "run", "src/server.py", "--host", "0.0.0.0", "--transport", "http"]
