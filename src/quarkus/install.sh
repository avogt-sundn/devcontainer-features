#!/bin/bash
set -e

VERSION="${VERSION:-3.19.4}"
DISABLETELEMETRY="${DISABLETELEMETRY:-true}"

curl -fsSL "https://github.com/quarkusio/quarkus/releases/download/${VERSION}/quarkus-cli-${VERSION}.tar.gz" \
  | tar xz -C /opt
ln -sf "/opt/quarkus-cli-${VERSION}/bin/quarkus" /usr/local/bin/quarkus
echo "Quarkus CLI ${VERSION} installed."

if [ "$DISABLETELEMETRY" = "true" ]; then
  REDHAT_DIR="${_REMOTE_USER_HOME:-/home/vscode}/.redhat"
  mkdir -p "$REDHAT_DIR"
  echo '{"disabled":true}' > "$REDHAT_DIR/io.quarkus.analytics.localconfig"
  chown -R "${_REMOTE_USER:-vscode}:${_REMOTE_USER:-vscode}" "$REDHAT_DIR"
  echo "Quarkus telemetry disabled."
fi
