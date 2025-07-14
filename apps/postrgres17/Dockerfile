# renovate: datasource=docker depName=ghcr.io/cloudnative-pg/postgresql
ARG CNPG_TAG="17.5-12"

FROM ghcr.io/cloudnative-pg/postgresql:$CNPG_TAG-bookworm

ARG CNPG_TAG
ARG POSTGRES_VERSION=${CNPG_TAG%.*}
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH

# renovate: datasource=github-releases depName=tensorchord/VectorChord
ARG VECTORCHORD_TAG="0.4.3"

# To install any package we need to be root
USER root

# Set architecture-specific package name
RUN case "${TARGETARCH}" in \
    "amd64") ARCH_SUFFIX="amd64" ;; \
    "arm64") ARCH_SUFFIX="arm64" ;; \
    *) echo "Unsupported architecture: ${TARGETARCH}" && exit 1 ;; \
    esac && \
    curl -L -o /tmp/vchord.deb \
    "https://github.com/tensorchord/VectorChord/releases/download/${VECTORCHORD_TAG}/postgresql-${POSTGRES_VERSION}-vchord_${VECTORCHORD_TAG}-1_${ARCH_SUFFIX}.deb" && \
    apt-get install -y /tmp/vchord.deb && \
    rm -f /tmp/vchord.deb

# Change to the uid of postgres (26)
USER postgres