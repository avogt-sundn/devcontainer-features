#!/bin/bash
set -e
. dev-container-features-test-lib

check "pdftotext available" which pdftotext
check "pdfinfo available" which pdfinfo
check "tesseract available" which tesseract
check "pandoc available" which pandoc
check "pdfplumber importable" python3 -c "import pdfplumber"
check "pymupdf importable" python3 -c "import fitz"
check "pypdf importable" python3 -c "import pypdf"
check "pdfminer importable" python3 -c "import pdfminer"
check "tabula importable" python3 -c "import tabula"

reportResults
