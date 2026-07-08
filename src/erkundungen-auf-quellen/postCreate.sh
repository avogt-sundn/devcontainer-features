#!/bin/bash
# Seedet workspace .claude/ aus dem Image-Share.
# Verwaltete Dateien (Agents, Tools, Grafiken) werden immer auf die aktuelle
# Feature-Version aktualisiert. Projekt-eigene Dateien werden einmalig angelegt;
# bei Versions-Mismatch erscheint ein Hinweis.
set -e

WORKSPACE="${1:-${containerWorkspaceFolder:-.}}"
SHARE="/usr/local/share/erkundungen-auf-quellen"
CLAUDE_SHARE="$SHARE/claude"
DEST="$WORKSPACE/.claude"
FEATURE_VERSION=$(cat "$SHARE/VERSION" 2>/dev/null || echo "unknown")

# Verwaltete Dateien: immer überschreiben — folgen stets der installierten Feature-Version
update() {
    local src="$1" dst="$2"
    mkdir -p "$(dirname "$dst")"
    cp "$src" "$dst"
    echo "[erkundungen-auf-quellen] updated: ${dst#"$WORKSPACE/"}"
}

# Projekt-eigene Dateien: einmalig anlegen (mit Version-Tag); bei Mismatch warnen
seed() {
    local src="$1" dst="$2"
    if [ ! -f "$dst" ]; then
        mkdir -p "$(dirname "$dst")"
        # Versions-Tag als erste Zeile in Markdown-Dateien einbetten
        case "$dst" in
            *.md) printf '<!-- erkundungen-auf-quellen: %s -->\n' "$FEATURE_VERSION" | cat - "$src" > "$dst" ;;
            *)    cp "$src" "$dst" ;;
        esac
        echo "[erkundungen-auf-quellen] seeded: ${dst#"$WORKSPACE/"} (v${FEATURE_VERSION})"
    else
        local file_version
        file_version=$(sed -n 's/.*erkundungen-auf-quellen: \([0-9][0-9.]*\).*/\1/p' "$dst" 2>/dev/null | head -1)
        if [ -n "$file_version" ] && [ "$file_version" != "$FEATURE_VERSION" ]; then
            echo "[erkundungen-auf-quellen] STALE: ${dst#"$WORKSPACE/"} (v${file_version} → v${FEATURE_VERSION})"
            echo "  → In Claude Code: 'Migriere diesen Workspace auf die aktuellen erkundungen-auf-quellen Konventionen'"
        fi
    fi
}

# Verwaltete Dateien — immer auf aktuellem Stand halten
for f in "$CLAUDE_SHARE/agents/"*; do
    update "$f" "$DEST/agents/$(basename "$f")"
done
for f in "$CLAUDE_SHARE/grafiken/"*; do
    update "$f" "$DEST/grafiken/$(basename "$f")"
done
for f in "$CLAUDE_SHARE/tools/"*; do
    update "$f" "$DEST/tools/$(basename "$f")"
done
update "$CLAUDE_SHARE/statusline-command.sh" "$DEST/statusline-command.sh"

# Globale Axiome — nur beim ersten Mal anlegen (user-global, nicht überschreiben)
seed "$CLAUDE_SHARE/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

# Projekt-eigene Dateien — einmalig anlegen, bei Versions-Abweichung warnen
seed "$SHARE/erkundungen-domain.md" "$WORKSPACE/erkundungen/DOMAIN.md"
