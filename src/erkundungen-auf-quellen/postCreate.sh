#!/bin/bash
# Seedet workspace .claude/ aus dem Image-Share — überschreibt keine bestehenden Dateien.
set -e

WORKSPACE="${1:-${containerWorkspaceFolder:-.}}"
SHARE="/usr/local/share/erkundungen-auf-quellen/claude"
DEST="$WORKSPACE/.claude"

seed() {
    local src="$1" dst="$2"
    if [ ! -f "$dst" ]; then
        mkdir -p "$(dirname "$dst")"
        cp "$src" "$dst"
        echo "[erkundungen-auf-quellen] seeded: ${dst#"$WORKSPACE/"}"
    fi
}

for f in "$SHARE/agents/"*; do
    seed "$f" "$DEST/agents/$(basename "$f")"
done

for f in "$SHARE/grafiken/"*; do
    seed "$f" "$DEST/grafiken/$(basename "$f")"
done

for f in "$SHARE/tools/"*; do
    seed "$f" "$DEST/tools/$(basename "$f")"
done

seed "$SHARE/statusline-command.sh" "$DEST/statusline-command.sh"

# Axiome global verfügbar machen — Claude Code liest ~/.claude/CLAUDE.md in jeder Session
seed "$SHARE/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
