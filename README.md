# devcontainer-features

Wiederverwendbare DevContainer-Features für Claude-Code-Projekte, veröffentlicht auf GHCR.

## Verfügbare Features

| Feature | Beschreibung | Referenz |
|---------|--------------|----------|
| `opencode` | Installiert OpenCode-Konfiguration ins User-Home | `ghcr.io/avogt-sundn/devcontainer-features/opencode:1` |
| `vertex-auth` | Stellt GCP-Config-Verzeichnis bereit; validiert Service-Account-JSON beim Container-Start | `ghcr.io/avogt-sundn/devcontainer-features/vertex-auth:1` |
| `build-mirrors` | Konfiguriert Maven + npm für lokale Docker-Netzwerk-Mirrors (Reposilite + Verdaccio) | `ghcr.io/avogt-sundn/devcontainer-features/build-mirrors:1` |
| `quarkus` | Installiert Quarkus CLI und deaktiviert optional Quarkus-Telemetrie | `ghcr.io/avogt-sundn/devcontainer-features/quarkus:1` |
| `springboot-cli` | Installiert Spring Boot CLI von Maven Central | `ghcr.io/avogt-sundn/devcontainer-features/springboot-cli:1` |
| `devtools` | Installiert Diagnose-Tools: ping, dig, telnet, ab, httpie, file | `ghcr.io/avogt-sundn/devcontainer-features/devtools:1` |
| `playwright` | Installiert Playwright OS-Systemabhängigkeiten (kein Chromium — Download via `make pw-install`) | `ghcr.io/avogt-sundn/devcontainer-features/playwright:1` |
| `claude-code` | Installiert Claude Code CLI global via npm | `ghcr.io/avogt-sundn/devcontainer-features/claude-code:1` |
| `copilot-cli` | Installiert GitHub Copilot CLI global via npm | `ghcr.io/avogt-sundn/devcontainer-features/copilot-cli:1` |

## Verwendung

In `devcontainer.json`:

```json
{
  "features": {
    "ghcr.io/avogt-sundn/devcontainer-features/opencode:1": {
      "model": "mlx/gemma-4-26b-a4b-it-mlx"
    },
    "ghcr.io/avogt-sundn/devcontainer-features/vertex-auth:1": {},
    "ghcr.io/avogt-sundn/devcontainer-features/build-mirrors:1": {},
    "ghcr.io/avogt-sundn/devcontainer-features/quarkus:1": {},
    "ghcr.io/avogt-sundn/devcontainer-features/springboot-cli:1": {}
  }
}
```

## Entwicklung

```bash
# Lokal testen (Docker erforderlich)
npm install -g @devcontainers/cli
devcontainer features test -f opencode .
devcontainer features test -f vertex-auth .
devcontainer features test -f build-mirrors .
devcontainer features test -f quarkus .
devcontainer features test -f springboot-cli .
devcontainer features test -f devtools .
devcontainer features test -f playwright .
devcontainer features test -f claude-code .
devcontainer features test -f copilot-cli .
```

## Veröffentlichung

Jeder Push auf `main` löst den Release-Workflow aus und veröffentlicht geänderte Features automatisch auf GHCR.
