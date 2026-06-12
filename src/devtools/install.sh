#!/bin/bash
set -e

apt-get update && apt-get install -y --no-install-recommends \
    iputils-ping \
    dnsutils \
    file \
    apache2-utils \
    httpie \
    telnet \
    && rm -rf /var/lib/apt/lists/*
