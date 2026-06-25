#!/bin/bash
# Runs at postCreateCommand — non-interactively applies common-standards config files to the workspace.
# Overwrites on every rebuild (coerce). Set COMMON_STANDARDS_FREEZE to opt out.
set -euo pipefail

# shellcheck source=/dev/null
source /usr/local/lib/devcontainer-features/common-standards.conf

CACHE="/usr/local/lib/common-standards"
WORKSPACE="${WORKSPACE_FOLDER:-$(pwd)}"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

CREATED=()
UPDATED=()
SKIPPED=()

# ── Freeze check ──────────────────────────────────────────────────────────────

if [[ -n "$COMMON_STANDARDS_FREEZE" ]]; then
  echo -e "[common-standards] ${YELLOW}freeze:${RESET} ${COMMON_STANDARDS_FREEZE}"
  echo -e "[common-standards] Auto-update suppressed. Run ${CYAN}sync-standards .${RESET} to update manually."
  exit 0
fi

# ── Apply primitive ───────────────────────────────────────────────────────────

apply_file() {
  local rel="$1"
  local src="$CACHE/$rel"
  local dst="$WORKSPACE/$rel"

  if [[ ! -f "$src" ]]; then
    return
  fi

  if [[ ! -f "$dst" ]]; then
    mkdir -p "$(dirname "$dst")"
    cp "$src" "$dst"
    CREATED+=("$rel")
  elif diff -q "$src" "$dst" &>/dev/null; then
    SKIPPED+=("$rel")
  else
    cp "$src" "$dst"
    UPDATED+=("$rel")
  fi
}

# ── Categories ────────────────────────────────────────────────────────────────
# pom.xml injection and eslint prefix substitution are interactive — use sync-standards for those.

IFS=',' read -ra CATS <<< "$COMMON_STANDARDS_CATEGORIES"
for cat in "${CATS[@]}"; do
  cat="${cat// /}"
  case "$cat" in
    universal)
      apply_file ".editorconfig"
      apply_file ".gitattributes"
      apply_file "DEVELOPING.md"
      ;;
    java)
      apply_file ".java-config/Common-Standards-Eclipse-Code-Profile.xml"
      apply_file ".java-config/Common-Standards-Eclipse-Clean-Up-Rules.xml"
      apply_file ".java-config/README.md"
      ;;
    frontend)
      apply_file ".prettierrc"
      apply_file ".prettierignore"
      ;;
    vscode)
      apply_file ".vscode/settings.json"
      apply_file ".vscode/extensions.json"
      ;;
    *)
      echo -e "[common-standards] ${YELLOW}Unknown category: ${cat} — skipped${RESET}"
      ;;
  esac
done

# ── Summary ───────────────────────────────────────────────────────────────────

echo ""
echo -e "${BOLD}[common-standards ${COMMON_STANDARDS_VERSION}]${RESET}"

if [[ ${#CREATED[@]} -gt 0 ]]; then
  echo -e "${GREEN}Created (${#CREATED[@]}):${RESET}"
  for f in "${CREATED[@]}"; do echo "  + $f"; done
fi

if [[ ${#UPDATED[@]} -gt 0 ]]; then
  echo -e "${YELLOW}Updated (${#UPDATED[@]}):${RESET}"
  for f in "${UPDATED[@]}"; do echo "  ~ $f"; done
fi

if [[ ${#SKIPPED[@]} -gt 0 ]]; then
  printf "${CYAN}Unchanged (%d): %s${RESET}\n" "${#SKIPPED[@]}" "${SKIPPED[*]}"
fi

TOTAL=$(( ${#CREATED[@]} + ${#UPDATED[@]} ))

if [[ $TOTAL -gt 0 ]]; then
  echo ""
  echo -e "${YELLOW}Workspace files changed — review and commit:${RESET}"
  echo -e "  git add -p && git commit -m \"style: apply common-standards ${COMMON_STANDARDS_VERSION}\""
  echo -e "  echo \"\$(git rev-parse HEAD)  # common-standards ${COMMON_STANDARDS_VERSION}\" >> .git-blame-ignore-revs"
  echo ""
  echo -e "  To opt out: set ${CYAN}\"freeze\": \"<reason>\"${RESET} in devcontainer.json"
else
  echo -e "${CYAN}All files up to date.${RESET}"
fi
