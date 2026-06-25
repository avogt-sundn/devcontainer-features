# common-standards

Wendet Formatierungs- und Linting-Konfiguration aus [`avogt-sundn/common-standards`](https://github.com/avogt-sundn/common-standards) bei **jedem Container-Rebuild** auf den Workspace an.

Ziel: Teams werden automatisch auf den aktuellen Stand der Standards gehoben — Abweichung erfordert explizites Opt-out.

## Verwendung

```json
"ghcr.io/avogt-sundn/devcontainer-features/common-standards:1": {}
```

Bei Rebuild erscheinen geänderte Dateien als Dirty Working Tree. Das ist beabsichtigt — kurzer Review, ein Commit, fertig.

## Optionen

| Option | Typ | Standard | Beschreibung |
|--------|-----|----------|--------------|
| `version` | string | `"main"` | Branch oder Tag von `common-standards` (z. B. `"v1.2.0"`) |
| `categories` | string | `"universal,java,frontend"` | Kommagetrennte Kategorien: `universal`, `java`, `frontend`, `vscode` |
| `freeze` | string | `""` | Begründungstext zum Deaktivieren der Auto-Updates (leer = aktiv) |

## Beispiele

### Standard — alle Updates automatisch

```json
"ghcr.io/avogt-sundn/devcontainer-features/common-standards:1": {}
```

### Bestimmte Version pinnen

```json
"ghcr.io/avogt-sundn/devcontainer-features/common-standards:1": {
  "version": "v1.2.0"
}
```

### Nur Java und universelle Dateien

```json
"ghcr.io/avogt-sundn/devcontainer-features/common-standards:1": {
  "categories": "universal,java"
}
```

### Opt-out (freeze)

```json
"ghcr.io/avogt-sundn/devcontainer-features/common-standards:1": {
  "freeze": "Legacy-Eclipse-Formatter im Einsatz, wird in PROJ-441 abgelöst"
}
```

Der Begründungstext wird bei jedem Container-Start angezeigt — sichtbarer sozialer Druck ohne Blockierung.

## Was wird automatisch angewendet

| Kategorie | Dateien |
|-----------|---------|
| `universal` | `.editorconfig`, `.gitattributes`, `DEVELOPING.md` |
| `java` | `.java-config/Common-Standards-Eclipse-Code-Profile.xml`, `.java-config/Common-Standards-Eclipse-Clean-Up-Rules.xml`, `.java-config/README.md` |
| `frontend` | `.prettierrc`, `.prettierignore` |
| `vscode` | `.vscode/settings.json`, `.vscode/extensions.json` |

## Was manuell via `sync-standards` erledigt werden muss

Folgende Schritte erfordern Interaktion und werden **nicht** automatisch ausgeführt:

- **Maven-Plugin-Injektion** (`pom.xml`) — Auswahl der Ziel-`pom.xml`, Berechnung des relativen Pfads zu `.java-config/`
- **ESLint-Konfiguration** (`eslint.config.js`) — Ersetzung des Angular-Komponentenpräfix

```bash
# Interaktiver Sync für Maven und ESLint:
sync-standards .
```

## Upgrade-Zyklus

Nach einem Rebuild mit geänderten Standards zeigt das Feature, welche Dateien aktualisiert wurden:

```
[common-standards v1.3.0]
Updated (2):
  ~ .editorconfig
  ~ .java-config/Common-Standards-Eclipse-Code-Profile.xml

Workspace files changed — review and commit:
  git add -p && git commit -m "style: apply common-standards v1.3.0"
  echo "$(git rev-parse HEAD)  # common-standards v1.3.0" >> .git-blame-ignore-revs
```

Der SHA in `.git-blame-ignore-revs` stellt sicher, dass `git blame` den Formatierungs-Commit überspringt.
