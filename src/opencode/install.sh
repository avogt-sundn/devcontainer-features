#!/bin/bash
set -e

npm install -g opencode-ai@latest

FEATURE_DIR="$(dirname "$0")"
TARGET="${_REMOTE_USER_HOME:-/home/vscode}/.config/opencode"

mkdir -p "$TARGET"

# [$] is a char class matching literal $; avoids sed $ end-of-line ambiguity
MODEL_VAL="${MODEL:-mlx/gemma-4-26b-a4b-it-mlx}"
sed "s|[\$]{MODEL}|${MODEL_VAL}|g" "$FEATURE_DIR/opencode.json" > "$TARGET/config.json"

chown -R "${_REMOTE_USER:-vscode}:${_REMOTE_USER:-vscode}" "$TARGET"
