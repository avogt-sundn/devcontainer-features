#!/bin/bash
set -e

# System-Abhängigkeiten für PDF- und Dokumenten-Verarbeitung
apt-get update && apt-get install -y --no-install-recommends \
    poppler-utils \
    tesseract-ocr \
    tesseract-ocr-deu \
    pandoc \
    && rm -rf /var/lib/apt/lists/*

# Python-Bibliotheken für PDF-Analyse und Tabellenextraktion
# tabula-py benötigt Java (im Basis-Image mcr.microsoft.com/devcontainers/java vorhanden)
pip install --quiet --break-system-packages \
    pdfplumber \
    pymupdf \
    pypdf \
    "pdfminer.six" \
    "camelot-py[cv]" \
    tabula-py
