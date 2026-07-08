FROM docker.io/library/alpine:3.24

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ENV HOME="/config" \
    XDG_CONFIG_HOME="/config" \
    XDG_DATA_HOME="/config" \
    DISPLAY=":0" \
    DISPLAY_WIDTH="1920" \
    DISPLAY_HEIGHT="1080" \
    TZ="Etc/UTC"

USER root
WORKDIR /app

# hadolint ignore=DL3018,DL3013
RUN apk add --no-cache --virtual .build-deps \
        gcc \
        gettext \
        musl-dev \
        python3-dev \
    && \
    apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
        chromaprint \
        curl \
        dbus \
        font-noto \
        libdiscid \
        libgit2 \
        mesa-dri-gallium \
        novnc \
        openbox \
        py3-charset-normalizer \
        py3-dateutil \
        py3-gobject3 \
        py3-jwt \
        py3-markdown \
        py3-mutagen \
        py3-pip \
        py3-qt6 \
        py3-pyqt6-sip \
        py3-yaml \
        python3 \
        qt6-qtbase \
        qt6-qtbase-x11 \
        qt6-qtmultimedia \
        qt6-qtsvg \
        tzdata \
        websockify \
        x11vnc \
        xdpyinfo \
        xvfb \
    && \
    pip install --no-cache-dir --no-deps --break-system-packages \
        "picard==${VERSION}" \
        "discid~=1.0" \
        "fasteners~=0.14" \
        "pygit2~=1.19" \
    && \
    apk del --no-cache .build-deps \
    && \
    adduser -D -u 1000 -h /config picard \
    && \
    mkdir -p /config /storage \
    && chown -R 1000:1000 /config /storage \
    && rm -rf /tmp/*

COPY ./apps/musicbrainz-picard/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER 1000:1000
VOLUME ["/config"]
EXPOSE 5800

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/metabrainz/picard"
