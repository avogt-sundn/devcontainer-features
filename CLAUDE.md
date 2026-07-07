# CLAUDE.md — devcontainer-features

Dieses Repository verwaltet wiederverwendbare DevContainer-Features, veröffentlicht auf GHCR unter `ghcr.io/avogt-sundn/devcontainer-features`.

---

## Repo-Struktur

```
src/<feature>/
├── devcontainer-feature.json   Metadaten + Version (semver, automatisch gebumpt)
├── install.sh                  Läuft im Container-Build als root
└── postCreate.sh               Optionaler postCreate-Hook (workspace-seitig)
test/<feature>/
└── test.sh                     Smoke-Tests via devcontainers/cli
Makefile                        Befehle: commit · test · lock · setup
hooks/pre-commit                Git-Hook: verhindert Commit ohne make commit
```

---

## Entwicklungs-Workflow

| Befehl | Was er tut |
|---|---|
| `make setup` | Installiert `hooks/pre-commit` als Git-Hook — einmalig nach Clone |
| `make commit` | Erkennt geänderte Features, bumpt Patch-Version in `devcontainer-feature.json`, staged `src/` und committet |
| `make test FEATURE=<name>` | Testet ein Feature lokal via `devcontainer features test` (Docker erforderlich) |
| `make lock` | Regeneriert `devcontainer-lock.json` im Parent-Repo (`../.devcontainer`) |

**Pflicht**: Nie direkt `git commit` — immer `make commit`. Der pre-commit-Hook erzwingt das. `make commit` bumpt die Version automatisch; manuelles Editieren der Version in `devcontainer-feature.json` überspringt das Bumping.

**CI**: Jeder Push auf `main` löst den Release-Workflow (`.github/`) aus und veröffentlicht geänderte Features auf GHCR.

---

## Feature: erkundungen-auf-quellen

Das komplexeste Feature — installiert Werkzeuge **und** seedet `.claude/` im Workspace.

### Was `install.sh` tut

- apt: `librsvg2-bin` (→ `rsvg-convert`), `pandoc`, `poppler-utils`, `tesseract-ocr-deu`
- pip: `pdfplumber`, `cairosvg`, `weasyprint`, `tabula-py` u. a.
- Kopiert `src/erkundungen-auf-quellen/claude/` nach `/usr/local/share/erkundungen-auf-quellen/claude/` im Image

### Was `postCreate.sh` tut

Seedet beim Container-Start aus dem Image-Share in den Workspace — **überschreibt keine bestehenden Dateien**:

| Quelle (Image-Share) | Ziel (Workspace) |
|---|---|
| `claude/agents/*.md` | `.claude/agents/` |
| `claude/grafiken/*` | `.claude/grafiken/` |
| `claude/tools/*` | `.claude/tools/` |
| `claude/statusline-command.sh` | `.claude/statusline-command.sh` |
| `claude/CLAUDE.md` | `~/.claude/CLAUDE.md` (global, alle Sessions) |

### Wichtige Konsequenz: Zwei Quellen, eine Wahrheit

Dateien unter `src/erkundungen-auf-quellen/claude/` sind die **Feature-Quelle** — sie werden beim nächsten Container-Build ins Image gebacken.

Dateien unter `.claude/` im konsumierenden Projekt (`../`) sind die **Live-Version** im laufenden Container — per `seed`-Logik befüllt, aber manuell überschreibbar.

Änderungen an Agents, Axiomen oder Grafik-Vorlagen müssen **an beiden Orten** gepflegt werden bis der Container neu gebaut wird:
1. `src/erkundungen-auf-quellen/claude/<pfad>` — Feature-Quelle (dieses Repo)
2. `../.claude/<pfad>` — Live-Version im aktuellen Container

### Grafik-Werkzeuge (EAQ-15)

`rsvg-convert` (aus `librsvg2-bin`) und `cairosvg` sind die SVG→PNG-Werkzeuge. Projektseitig nutzt `scripts/svg-to-png.sh` standardmäßig `rsvg-convert`.

Diagramm-Strategie aus `claude/CLAUDE.md` (EAQ-15):
- **Mermaid**: Standard-Typen inline im Markdown
- **SVG**: Swimlane, custom Layout, Repo-Designsprache → begleitendes PNG via `rsvg-convert`
- **ASCII-Grafiken**: verboten

---

## Axiome (für Arbeit in diesem Repo)

- **[EAQ-3] Lesen vor Schreiben.** Vor jeder Änderung an `devcontainer-feature.json` oder `install.sh` die aktuelle Version lesen.
- **[EAQ-5] Minimaler Fußabdruck.** Nur das Beauftragte ändern — kein opportunistisches Aufräumen in anderen Features.
- **[EAQ-6] Stille Standards benennen.** Neue apt-Pakete oder pip-Dependencies vor dem Schreiben deklarieren.
- **[EAQ-7] Explizite Bestätigung vor irreversiblen Aktionen.** `make commit` + Push auf `main` triggert GHCR-Publish — vor dem Push bestätigen lassen.
- **[EAQ-15] Keine ASCII-Grafiken.** Gilt auch in Feature-Dokumentation — Mermaid oder SVG.

---

## Verlauf

- 2026-07-07 — Erstfassung
