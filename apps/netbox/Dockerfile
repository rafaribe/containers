ARG VERSION
FROM ghcr.io/netbox-community/netbox:${VERSION}

# Change ownership of netbox directories to ubuntu user (UID 1000)
RUN chown -R 1000:1000 /opt/netbox/ \
    && chown -R 1000:1000 /etc/netbox/ \ 
    && chown -R 1000:1000 /opt/unit/

# Switch to non-root user
USER 1000

LABEL org.opencontainers.image.source="https://github.com/netbox-community/netbox"
