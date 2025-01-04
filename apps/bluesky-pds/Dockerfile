FROM docker.io/library/alpine:3.21 AS pds-build

ARG VERSION=0.4.74

RUN apk add --no-cache \
    bash \
    ca-certificates \
    curl \
    git \
    unzip \
    nodejs \
    npm

RUN npm install -g pnpm

# Download and extract the PDS archive
WORKDIR /app
RUN curl -fsSL -o pds.zip "https://github.com/bluesky-social/pds/archive/refs/tags/v${VERSION}.zip" && \
    unzip pds.zip && \
    mv pds-${VERSION}/service/** . && \
    mv pds-${VERSION}/pdsadmin.sh . && \
    rm -rf pds.zip pds-${VERSION}

RUN pnpm install --prod=true --frozen-lockfile

FROM docker.io/library/alpine:3.21

RUN apk add --no-cache \
    catatonit \
    ca-certificates \
    curl \
    gnupg \
    jq \
    openssl \
    sqlite \
    util-linux

WORKDIR /app
COPY --from=pds-build /app /app

EXPOSE 3000

ENV PUID=1000
ENV PGID=1000

RUN addgroup --gid ${PGID} pds && \
    adduser --home ${PDS_DATADIR} --uid ${PUID} --ingroup pds --disabled-password pds && \
    chown -R pds:pds ${PDS_DATADIR}

COPY apps/bluesky-pds/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]