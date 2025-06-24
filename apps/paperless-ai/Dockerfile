ARG VERSION
FROM node:22-slim

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

WORKDIR /app

# Install system dependencies and clean up in single layer
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-dev \
    python3-venv \
    make \
    g++ \
    curl \
    wget \
    git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install PM2 process manager globally
RUN npm install pm2 -g

# Clone paperless-ai repository at the specified version
RUN git clone --depth 1 --branch v${VERSION} https://github.com/clusterzx/paperless-ai.git /tmp/paperless-ai && \
    cp -r /tmp/paperless-ai/* /app/ && \
    rm -rf /tmp/paperless-ai

# Install node dependencies with clean install first (smaller downloads)
RUN npm ci --only=production && npm cache clean --force

# Install Python dependencies for RAG service in a virtual environment
RUN python3 -m venv /app/venv
ENV PATH="/app/venv/bin:$PATH"

# Install Python dependencies with retry logic and timeout settings
RUN pip install --upgrade pip && \
    pip install --no-cache-dir --timeout=300 --retries=3 \
    fastapi>=0.95.0 \
    uvicorn>=0.21.1 \
    python-dotenv>=1.0.0 \
    requests>=2.28.2 \
    pydantic>=1.10.7 \
    tqdm>=4.65.0 \
    nltk>=3.8.1 \
    rank-bm25>=0.2.2

# Install ML dependencies separately (these are the large ones that might timeout)
RUN pip install --no-cache-dir --timeout=600 --retries=5 \
    numpy>=1.24.2 \
    torch>=2.0.0 --index-url https://download.pytorch.org/whl/cpu

# Install remaining ML dependencies
RUN pip install --no-cache-dir --timeout=300 --retries=3 \
    sentence-transformers>=2.2.2 \
    chromadb>=0.3.21

# Make startup script executable
RUN chmod +x start-services.sh

# Configure persistent data volume
VOLUME ["/app/data"]

# Configure application port
EXPOSE ${PAPERLESS_AI_PORT:-3000}

# Add health check with dynamic port
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:${PAPERLESS_AI_PORT:-3000}/health || exit 1

# Set production environment
ENV NODE_ENV=production

# Start both Node.js and Python services using our script
CMD ["./start-services.sh"]

LABEL org.opencontainers.image.source="https://github.com/clusterzx/paperless-ai"
