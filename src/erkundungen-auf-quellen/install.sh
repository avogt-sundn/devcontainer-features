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

# Claude Code — portable agents, tools, grafiken, statusline
FEATURE_DIR="$(dirname "$0")"
CLAUDE_HOME="/home/vscode/.claude"

mkdir -p "$CLAUDE_HOME/agents" "$CLAUDE_HOME/grafiken" "$CLAUDE_HOME/tools"

cp "$FEATURE_DIR/claude/CLAUDE.md" "$CLAUDE_HOME/CLAUDE.md"
cp -r "$FEATURE_DIR/claude/agents/." "$CLAUDE_HOME/agents/"
cp -r "$FEATURE_DIR/claude/grafiken/." "$CLAUDE_HOME/grafiken/"
cp -r "$FEATURE_DIR/claude/tools/." "$CLAUDE_HOME/tools/"
cp "$FEATURE_DIR/claude/statusline-command.sh" "$CLAUDE_HOME/statusline-command.sh"

# npm-Abhängigkeiten für Tools (playwright-core u. a.)
cd "$CLAUDE_HOME/tools" && npm install --prefer-offline 2>/dev/null || true

chown -R vscode:vscode "$CLAUDE_HOME"
