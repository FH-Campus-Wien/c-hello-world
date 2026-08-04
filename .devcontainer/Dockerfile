FROM mcr.microsoft.com/devcontainers/base:1-debian-12

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        gcc \
        gdb \
        libc6-dev \
        make \
    && rm -rf /var/lib/apt/lists/*
