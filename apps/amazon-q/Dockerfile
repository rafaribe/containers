# syntax=docker/dockerfile:1

ARG VERSION
FROM docker.io/library/ubuntu:24.04

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ENV DEBIAN_FRONTEND="noninteractive" \
    TERM="xterm-256color" \
    TZ="Etc/UTC"

USER root
WORKDIR /app

# Install common dependencies
#hadolint ignore=DL3008,DL3009,DL3015
RUN \
    apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
        ca-certificates \
        curl \
        git \
        jq \
        sqlite3 \
        tzdata \
        unzip \
        vim \
        wget \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install AWS CLI and Amazon Q CLI with architecture detection
RUN \
    case "${TARGETPLATFORM}" in \
        'linux/amd64') export ARCH_AWS='x86_64' ;; \
        'linux/arm64') export ARCH_AWS='aarch64' ;; \
    esac \
    && curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-${ARCH_AWS}.zip" -o awscliv2.zip \
    && curl --proto '=https' --tlsv1.2 -sSf "https://desktop-release.q.us-east-1.amazonaws.com/latest/q-${ARCH_AWS}-linux.zip" -o q.zip \
    && unzip awscliv2.zip && ./aws/install && rm -rf awscliv2.zip ./aws \
    && unzip q.zip -d /tmp && chmod +x /tmp/q/install.sh && Q_INSTALL_GLOBAL=true /tmp/q/install.sh \
    && rm -rf q.zip /tmp/q

# Create non-root user and set up directories
RUN \
    useradd -ms /bin/bash dev \
    && mkdir -p /home/dev/src /home/dev/.aws/amazonq/profiles /home/dev/.ssh \
    && mkdir -p /home/dev/.local/share/amazon-q /home/dev/.cache/amazon-q \
    && chown -R dev:dev /home/dev

# Switch to non-root user
USER dev
WORKDIR /home/dev/src

# Set up shell prompt and initialize SQLite database
RUN \
    echo 'export PS1="\[\033[01;32m\]q-dev\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "' >> /home/dev/.bashrc \
    && mkdir -p /home/dev/.local/share/amazon-q \
    && touch /home/dev/.local/share/amazon-q/data.sqlite3 \
    && chmod 644 /home/dev/.local/share/amazon-q/data.sqlite3

# Install mise for managing multiple language runtimes
RUN \
    curl https://mise.run | sh \
    && echo 'eval "$(~/.local/bin/mise activate --shims bash)"' >> ~/.bashrc \
    && eval "$(~/.local/bin/mise activate --shims bash)" \
    && ~/.local/bin/mise use -g python@latest uv@latest node@lts java@latest go@latest

VOLUME ["/home/dev/src", "/home/dev/.aws", "/home/dev/.local/share/amazon-q", "/home/dev/.cache/amazon-q"]

# Default command starts Amazon Q chat
ENTRYPOINT ["q"]
CMD ["chat"]

LABEL org.opencontainers.image.source="https://github.com/aws/amazon-q-developer-cli"
