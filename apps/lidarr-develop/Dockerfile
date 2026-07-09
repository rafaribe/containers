FROM docker.io/library/alpine:3.24

ARG VERSION
ARG CHANNEL

ENV UMASK="0002" \
    TZ="Etc/UTC" \
    XDG_CONFIG_HOME="/config" \
    XDG_DATA_HOME="/config"

USER root
WORKDIR /app

#hadolint ignore=DL3018
RUN apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
        chromaprint \
        coreutils \
        curl \
        icu-libs \
        jq \
        sqlite-libs \
        tzdata

RUN case "$(uname -m)" in \
        'x86_64') ARCH="x64" ;; \
        'aarch64') ARCH="arm64" ;; \
    esac \
    && mkdir -p /app/bin \
    && curl -fsSL \
        "https://lidarr.servarr.com/v1/update/develop/updatefile?version=${VERSION}&os=linuxmusl&runtime=netcore&arch=${ARCH}" \
        | tar xzf - -C /app/bin --strip-components=1 \
    && rm -rf /app/bin/Lidarr.Update \
    && printf "PackageVersion=%s\nPackageAuthor=[rafaribe](https://github.com/rafaribe)\nUpdateMethod=Docker\nBranch=lidarr-plugins\n" "${VERSION}" > /app/package_info \
    && chmod -R u=rwX,go=rX /app \
    && rm -rf /tmp/*

COPY ./apps/lidarr-develop/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && mkdir -p /config && chown 1000:1000 /config

USER 1000:1000
WORKDIR /config
VOLUME ["/config"]

EXPOSE 8686

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/Lidarr/Lidarr"
