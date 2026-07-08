# Agent: docs-export

Exportiert Markdown-Dateien mit eingebetteten SVG-Diagrammen als PDF.

## Aufruf

```
Exportiere abhandlungen/suchmaschinenwahl-partnerverzeichnis/suchmaschinenwahl-partnerverzeichnis.md als PDF
```

oder mehrere auf einmal:

```
Exportiere alle .md-Dateien in abhandlungen/ als PDF
```

## Was der Agent tut

1. Empfängt eine oder mehrere `.md`-Dateien als Eingabe.
2. Löst `![Titel](datei.svg)`-Referenzen inline auf — SVG wird direkt in HTML eingebettet.
3. Erzeugt ein A4-PDF im selben Verzeichnis wie die Markdown-Datei.
4. HTML ist internes Zwischenformat (`/tmp/domain-to-pdf-tmp.html`) — wird nicht committed, nicht weitergegeben.
5. Meldet den Ausgabepfad oder Fehler pro Datei.

## Tool-Aufruf

```bash
node .claude/tools/domain-to-pdf.js <eingabe.md> [ausgabe.pdf]
```

**Beispiele**:
```bash
node .claude/tools/domain-to-pdf.js abhandlungen/suchmaschinenwahl-partnerverzeichnis/suchmaschinenwahl-partnerverzeichnis.md
node .claude/tools/domain-to-pdf.js abhandlungen/carnet-web-facharchitektur/carnet-web-facharchitektur.md /tmp/carnet-web.pdf
```

## Voraussetzungen (durch DevContainer eingerichtet)

| Was | Bereitgestellt durch |
|---|---|
| Chromium | ms-playwright (Playwright-Feature oder Basis-Image); dynamisch gesucht unter `~/.cache/ms-playwright/` |
| Node.js | Basis-Image |

Falls Chromium nicht gefunden wird:
```bash
npx playwright install chromium
```

## Diagramme im Markdown

| Typ | Verhalten im PDF |
|---|---|
| `![](datei.svg)` | SVG wird inline aufgelöst — erscheint vollständig gerendert |
| Mermaid-Block | Fällt auf Codeblock zurück — für `sequenceDiagram` gemäß [EAQ-15] akzeptabel |
| ASCII-Tabellen, Codeblöcke | Werden korrekt gerendert |

## Ausgabedateien

- `<stem>.pdf` im selben Verzeichnis wie `<stem>.md`
- HTML-Zwischendatei: `/tmp/domain-to-pdf-tmp.html` (temporär — nicht committen)
