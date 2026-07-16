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
    ffmpeg \
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
cp -r "$FEATURE_DIR/scripts" "$SHARE/scripts"
cp "$FEATURE_DIR/postCreate.sh" "$SHARE/postCreate.sh"
cp "$FEATURE_DIR/erkundungen-domain.md" "$SHARE/erkundungen-domain.md"
chmod +x "$SHARE/postCreate.sh"
chmod +x "$SHARE/scripts/"*.sh

# Whisper-CLI — schickt Audio an den Whisper-Server auf dem Host-Mac
cat > /usr/local/bin/whisper << 'WHISPER_CLI'
#!/usr/bin/env bash
# Transkribiert eine Audio-/Videodatei via Whisper-Server auf dem Host-Mac.
# Verwendung: whisper <datei>
set -euo pipefail

if [[ $# -eq 0 ]]; then
  echo "Verwendung: whisper <datei>" >&2
  exit 1
fi

API="${WHISPER_API:-http://192.168.64.1:8765}"
FILE="$1"

curl -sf -X POST "${API}/v1/audio/transcriptions" \
  -F "file=@${FILE}" \
  | python3 -c "import sys,json; print(json.load(sys.stdin)['text'])"
WHISPER_CLI
chmod +x /usr/local/bin/whisper

# Feature-Version für Laufzeit-Versionsvergleiche persistieren
python3 -c "import json; print(json.load(open('$FEATURE_DIR/devcontainer-feature.json'))['version'])" > "$SHARE/VERSION"
