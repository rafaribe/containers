ARG VERSION
FROM docker.io/g33kphr33k/musicgrabber:${VERSION}

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

USER root

# Fix entrypoint permissions and remove gosu dependency —
# Kubernetes securityContext handles UID/GID, so we bypass the
# original entrypoint and run uvicorn directly.
RUN chmod 755 /app/entrypoint.sh && \
    chown -R 1000:1000 /app /data 2>/dev/null || true

USER 1000:1000
WORKDIR /app

EXPOSE 8080

ENTRYPOINT []
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8080"]

LABEL org.opencontainers.image.source="https://github.com/g33kphr33k/musicgrabber"
