#!/bin/bash
set -e

mkdir -p "${_REMOTE_USER_HOME:-/home/vscode}/.config/gcp"
chown -R "${_REMOTE_USER:-vscode}:${_REMOTE_USER:-vscode}" "${_REMOTE_USER_HOME:-/home/vscode}/.config/gcp"

# Install the postCreate validation script at a fixed path in the image
mkdir -p /usr/local/lib/devcontainer-features
cp "$(dirname "$0")/validate.sh" /usr/local/lib/devcontainer-features/vertex-auth-validate.sh
chmod +x /usr/local/lib/devcontainer-features/vertex-auth-validate.sh
