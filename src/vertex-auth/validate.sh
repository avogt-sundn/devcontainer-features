#!/usr/bin/env bash

set -e

CREDENTIAL_FILE="${GOOGLE_APPLICATION_CREDENTIALS:-/home/vscode/.config/gcp/vertex-service-account.json}"

if [ ! -r "$CREDENTIAL_FILE" ]; then
	echo "[vertex-auth] Vertex credential file not found/readable: $CREDENTIAL_FILE" >&2
	echo "[vertex-auth] Lege die Datei auf dem Host unter ~/.config/gcp/vertex-service-account.json ab." >&2
	exit 1
fi

python3 - "$CREDENTIAL_FILE" <<'PY'
import json
import sys

path = sys.argv[1]
with open(path, "r", encoding="utf-8") as fh:
	data = json.load(fh)

missing = [k for k in ("project_id", "client_email", "private_key") if not data.get(k)]
if missing:
	print(
		f"[vertex-auth] Invalid Vertex service account JSON. Missing keys: {', '.join(missing)}",
		file=sys.stderr,
	)
	sys.exit(1)

print("[vertex-auth] Vertex credentials detected and validated.")
PY
