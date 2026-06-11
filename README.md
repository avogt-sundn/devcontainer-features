# devcontainer-features

Wiederverwendbare DevContainer-Features für Claude-Code-Projekte, veröffentlicht auf GHCR.

## Verfügbare Features

| Feature | Beschreibung | Referenz |
|---------|--------------|----------|
| `opencode` | Installiert OpenCode-Konfiguration ins User-Home | `ghcr.io/avogt-sundn/devcontainer-features/opencode:1` |
| `vertex-auth` | Stellt GCP-Config-Verzeichnis bereit; validiert Service-Account-JSON beim Container-Start | `ghcr.io/avogt-sundn/devcontainer-features/vertex-auth:1` |

## Verwendung

In `devcontainer.json`:

```json
{
  "features": {
    "ghcr.io/avogt-sundn/devcontainer-features/opencode:1": {
      "model": "mlx/gemma-4-26b-a4b-it-mlx"
    },
    "ghcr.io/avogt-sundn/devcontainer-features/vertex-auth:1": {}
  }
}
```

## Entwicklung

```bash
# Lokal testen (Docker erforderlich)
npm install -g @devcontainers/cli
devcontainer features test -f opencode .
devcontainer features test -f vertex-auth .
```

## Veröffentlichung

Jeder Push auf `main` löst den Release-Workflow aus und veröffentlicht geänderte Features automatisch auf GHCR.
