FROM bitnami/nginx:1.25

# Install curl
USER root
RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*

USER 1001