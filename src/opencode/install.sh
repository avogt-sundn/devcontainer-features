#!/bin/bash
set -e

FEATURE_DIR="$(dirname "$0")"
TARGET="${_REMOTE_USER_HOME:-/home/vscode}/.config/opencode"

mkdir -p "$TARGET"

# Substitute MODEL option into the config
sed "s|\${MODEL}|${MODEL:-mlx/gemma-4-26b-a4b-it-mlx}|g" "$FEATURE_DIR/opencode.json" > "$TARGET/config.json"

chown -R "${_REMOTE_USER:-vscode}:${_REMOTE_USER:-vscode}" "$TARGET"
