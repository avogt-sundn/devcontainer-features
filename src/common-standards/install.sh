#!/bin/bash
set -e

VERSION="${VERSION:-main}"
FREEZE="${FREEZE:-}"
CATEGORIES="${CATEGORIES:-universal,java,frontend}"
CACHE="/usr/local/lib/common-standards"
SCRIPTS="/usr/local/lib/devcontainer-features"

# Download common-standards archive
if [ "$VERSION" = "main" ]; then
  URL="https://github.com/avogt-sundn/common-standards/archive/refs/heads/main.tar.gz"
else
  URL="https://github.com/avogt-sundn/common-standards/archive/refs/tags/${VERSION}.tar.gz"
fi

echo "[common-standards] Downloading ${VERSION} ..."
curl -fsSL "$URL" | tar -xz -C /tmp
EXTRACTED=$(find /tmp -maxdepth 1 -name "common-standards-*" -type d | head -1)
rm -rf "$CACHE"
mv "$EXTRACTED" "$CACHE"

# Make sync-standards available as an interactive CLI
chmod +x "$CACHE/bin/sync-standards.sh"
ln -sf "$CACHE/bin/sync-standards.sh" /usr/local/bin/sync-standards

# Bake feature options into a conf file read by apply.sh at postCreateCommand time
mkdir -p "$SCRIPTS"
cat > "$SCRIPTS/common-standards.conf" << CONF
COMMON_STANDARDS_VERSION="${VERSION}"
COMMON_STANDARDS_FREEZE="${FREEZE}"
COMMON_STANDARDS_CATEGORIES="${CATEGORIES}"
CONF

# Install the apply script that postCreateCommand will invoke
cp "$(dirname "$0")/apply.sh" "$SCRIPTS/common-standards-apply.sh"
chmod +x "$SCRIPTS/common-standards-apply.sh"

echo "[common-standards] Installed. Apply script will run at postCreateCommand."
