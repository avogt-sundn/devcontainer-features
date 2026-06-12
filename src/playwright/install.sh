#!/bin/bash
set -e

VERSION="${VERSION:-1.58.2}"

apt-get update && apt-get install -y --no-install-recommends \
    xvfb \
    libglib2.0-0 \
    libgbm1 \
    libgtk-3-0 \
    libnss3 \
    libasound2 \
    libxtst6 \
    libatk-bridge2.0-0 \
    libdrm2 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libpango-1.0-0 \
    libcairo2 \
    && rm -rf /var/lib/apt/lists/*

export PLAYWRIGHT_BROWSERS_PATH=/ms-playwright
npx --yes "playwright@${VERSION}" install chromium
chmod -R 777 /ms-playwright
