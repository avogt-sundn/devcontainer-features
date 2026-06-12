#!/bin/bash
set -e

FEATURE_DIR="$(dirname "$0")"
TARGET="${_REMOTE_USER_HOME:-/home/vscode}/.config/opencode"

mkdir -p "$TARGET"

# Use python3 to substitute MODEL; avoids sed $ metacharacter ambiguity
MODEL_VAL="${MODEL:-mlx/gemma-4-26b-a4b-it-mlx}"
python3 - "$FEATURE_DIR/opencode.json" "$TARGET/config.json" "$MODEL_VAL" <<'PY'
import sys
src, dst, model = sys.argv[1], sys.argv[2], sys.argv[3]
with open(src) as f:
    content = f.read()
with open(dst, 'w') as f:
    f.write(content.replace('${MODEL}', model))
PY

chown -R "${_REMOTE_USER:-vscode}:${_REMOTE_USER:-vscode}" "$TARGET"
