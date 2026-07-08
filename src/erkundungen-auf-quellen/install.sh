#!/bin/bash
set -e

apt-get update && apt-get install -y --no-install-recommends \
    poppler-utils \
    tesseract-ocr \
    tesseract-ocr-deu \
    pandoc \
    librsvg2-bin \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libgdk-pixbuf2.0-0 \
    libffi-dev \
    shared-mime-info \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# tabula-py benötigt Java (im Basis-Image mcr.microsoft.com/devcontainers/java vorhanden)
python3 -m pip install --quiet --break-system-packages \
    pdfplumber \
    pymupdf \
    pypdf \
    "pdfminer.six" \
    "camelot-py[cv]" \
    tabula-py \
    weasyprint \
    reportlab \
    fpdf2 \
    cairosvg

# Chromium — wird von domain-to-pdf.js und svg-to-png.js benötigt.
# Wird NICHT hier installiert: kommt aus dem Playwright-Feature oder dem Basis-Image
# (gesucht unter ~/.cache/ms-playwright/chromium-*/chrome-linux/chrome).
# Falls nicht vorhanden: npx playwright install chromium
#
# rsvg-convert (aus librsvg2-bin oben) ist die Chromium-freie Alternative für SVG→PNG.

# Claude Code — Dateien in Image-Share ablegen; postCreate.sh seedet den Workspace
FEATURE_DIR="$(dirname "$0")"
SHARE="/usr/local/share/erkundungen-auf-quellen"

mkdir -p "$SHARE"
cp -r "$FEATURE_DIR/claude" "$SHARE/claude"
cp "$FEATURE_DIR/postCreate.sh" "$SHARE/postCreate.sh"
chmod +x "$SHARE/postCreate.sh"
