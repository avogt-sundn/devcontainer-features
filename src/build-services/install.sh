#!/bin/bash
set -e

NETWORK="${NETWORK:-docker-default-network}"
FEATURE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST=/usr/local/lib/devcontainer-features/build-services

mkdir -p "$DEST"
cp "$FEATURE_DIR/docker-compose.yaml" "$DEST/"
cp -r "$FEATURE_DIR/maven-mirror" "$DEST/"
cp -r "$FEATURE_DIR/npm-mirror" "$DEST/"

cat > /usr/local/lib/devcontainer-features/build-services-start.sh <<SCRIPT
#!/bin/bash
set -e
NETWORK="${NETWORK}"

docker network create "\$NETWORK" 2>/dev/null || true

cd /usr/local/lib/devcontainer-features/build-services
docker compose --profile mirrors up -d --build
echo "[build-services] Mirrors started on network \$NETWORK."
SCRIPT

chmod +x /usr/local/lib/devcontainer-features/build-services-start.sh
