ARG VERSION
FROM ghcr.io/netbox-community/netbox:${VERSION}

# Create nonroot user with UID 1000 and set ownership
RUN adduser --disabled-password --uid 1000 --gecos "" nonroot \
    && chown -R 1000 /opt/netbox/ \
    && chown -R 1000 /etc/netbox/

# Switch to non-root user
USER nonroot

LABEL org.opencontainers.image.source="https://github.com/netbox-community/netbox"
