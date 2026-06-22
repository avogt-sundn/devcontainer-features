#!/bin/bash
set -e

npm install -g opencode-ai@latest

FEATURE_DIR="$(dirname "$0")"
TARGET="${_REMOTE_USER_HOME:-/home/vscode}/.config/opencode"
mkdir -p "$TARGET"

PRESET="${PRESET:-mlx/gemma-4-26b-a4b-it-mlx}"
PROVIDER="${PRESET%%/*}"
MODEL_ID="${PRESET#*/}"

# Set the default model and register it in the provider's models map so opencode can list it
jq --arg model    "$PRESET" \
   --arg provider "$PROVIDER" \
   --arg model_id "$MODEL_ID" \
   '.model = $model |
    if .provider[$provider] then
      .provider[$provider].models[$model_id] //= {"name": $model_id}
    else . end' \
   "$FEATURE_DIR/opencode.json" > "$TARGET/config.json"

chown -R "${_REMOTE_USER:-vscode}:${_REMOTE_USER:-vscode}" "$TARGET"
