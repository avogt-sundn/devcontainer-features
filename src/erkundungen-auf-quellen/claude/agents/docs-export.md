# Agent: docs-export

Exportiert Markdown-Dateien mit Mermaid-Diagrammen als HTML und PDF.

## Aufruf

```
Exportiere docs/acl/ACL-ARCHITEKTUR.md als HTML und PDF
```

oder mehrere auf einmal:

```
Exportiere alle Markdown-Dateien in docs/acl/ als HTML und PDF
```

## Was der Agent tut

1. Empfängt eine oder mehrere `.md`-Dateien als Eingabe
2. Rendert alle ` ```mermaid ` Blöcke via `mmdc` zu SVG (Chromium, lokal)
3. Baut eine gestylte HTML-Datei mit inline-SVG im selben Verzeichnis
4. Generiert ein A4-PDF via Playwright Chromium
5. Meldet Erfolg oder Fehler pro Datei

## Tool-Aufruf

```bash
node .claude/tools/domain-to-pdf.js <eingabe.md> [ausgabe.pdf]
```

**Beispiele**:
```bash
node .claude/tools/domain-to-pdf.js erkundungen/wie-modelliert-man-das-carnet-datenmodell/DOMAIN.md
node .claude/tools/domain-to-pdf.js erkundungen/wie-schuetzt-ein-acl-das-erp-vor-der-externen-api/DOMAIN.md
node .claude/tools/domain-to-pdf.js erkundungen/wie-kommt-ein-neuer-kunde-ins-system/DOMAIN.md /tmp/kundenaufnahme.pdf
```

## Voraussetzungen (bereits im DevContainer eingerichtet)

| Was | Status |
|---|---|
| `mmdc` (mermaid-cli) | `npm install -g @mermaid-js/mermaid-cli` — global installiert |
| `marked` | `cd /tmp && npm install marked` |
| `playwright` | `cd /tmp && npm install playwright` |
| Puppeteer-Konfig | `/tmp/puppeteer-cfg.json` vorhanden |
| Chromium | `/ms-playwright/chromium-1208/chrome-linux/chrome` |

Falls `/tmp/puppeteer-cfg.json` fehlt (nach Container-Neustart):
```bash
echo '{"executablePath":"/ms-playwright/chromium-1208/chrome-linux/chrome","args":["--no-sandbox","--disable-setuid-sandbox"]}' > /tmp/puppeteer-cfg.json
```

Falls `/tmp/node_modules` fehlt (nach Container-Neustart):
```bash
cd /tmp && npm install marked playwright
```

## Regeln für Mermaid in Markdown-Dateien dieses Repos

Damit `mmdc` fehlerfrei rendert, gelten folgende Einschränkungen:

| Verboten | Erlaubt stattdessen |
|---|---|
| Semikolons `;` in Labels/Notes | Komma `,` oder Satz ohne Semikolon |
| HTML-Entities `&lt;` `&gt;` | Tilde-Notation `~Typ~` für Generics |
| `<br/>` oder `<br>` in Labels | Leerzeichen oder Zeilenumbruch via `\n` in `["..."]` |
| `<` `>` als Vergleichsoperatoren | ausschreiben: "unter 24 h" statt "< 24 h" |

## Ausgabedateien

Neben der `.md`-Datei entstehen:
- `<stem>.html` — eigenständiges HTML mit eingebetteten SVG-Diagrammen
- `<stem>.pdf` — A4-PDF, druckoptimiert

## Fehlerbehandlung

Schlägt ein einzelnes Mermaid-Diagramm fehl, wird an seiner Stelle ein roter Fehlertext eingebettet — die übrigen Diagramme und das restliche Dokument werden trotzdem exportiert.
