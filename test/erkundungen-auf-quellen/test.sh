#!/bin/bash
set -e
. dev-container-features-test-lib

# PDF lesen / OCR
check "pdftotext available" which pdftotext
check "pdfinfo available" which pdfinfo
check "tesseract available" which tesseract
check "pdfplumber importable" python3 -c "import pdfplumber"
check "pymupdf importable" python3 -c "import fitz"
check "pypdf importable" python3 -c "import pypdf"
check "pdfminer importable" python3 -c "import pdfminer"
check "tabula importable" python3 -c "import tabula"

# PDF schreiben
check "weasyprint importable" python3 -c "import weasyprint"
check "reportlab importable" python3 -c "import reportlab"
check "fpdf2 importable" python3 -c "import fpdf"

# SVG → PNG
check "rsvg-convert available" which rsvg-convert
check "cairosvg importable" python3 -c "import cairosvg"

# Confluence-Markup (pandoc -t jira)
check "pandoc available" which pandoc
check "pandoc jira output" bash -c "printf '# Test\n' | pandoc -f markdown -t jira"

reportResults
