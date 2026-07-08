# Agent: svg-to-png

Wandelt SVG-Dateien in PNG-Rastergrafiken um — für Confluence-Uploads, Präsentationen oder Dokumentenexport.

## Aufruf

```
Konvertiere abhandlungen/suchmaschinenwahl-partnerverzeichnis/fig-architektur.svg nach PNG
```

oder mehrere auf einmal:

```
Konvertiere alle SVGs in abhandlungen/carnet-web-facharchitektur/ nach PNG
```

---

## Was der Agent tut

1. SVG-Dateien identifizieren (Shell-Glob oder einzelne Pfade).
2. PNG im selben Verzeichnis erzeugen — Dateiname identisch (`.svg` → `.png`).
3. Ausgabe: Dateiname und Pixelgröße.

---

## Tool-Aufruf — Primärmethode: `rsvg-convert`

```bash
rsvg-convert -o datei.png datei.svg
```

Mit fester Breite (empfohlen für Confluence, 1200 px):
```bash
rsvg-convert -w 1200 -o datei.png datei.svg
```

Mehrere Dateien per Shell-Glob:
```bash
for f in abhandlungen/carnet-web-facharchitektur/*.svg; do
    rsvg-convert -w 1200 -o "${f%.svg}.png" "$f"
done
```

`rsvg-convert` ist durch `librsvg2-bin` im DevContainer verfügbar — kein Chromium, kein Node.js erforderlich.

---

## Alternativmethode: Node.js-Tool (Playwright/Chromium)

Für pixelgenaue Skalierung oder wenn `rsvg-convert` Rendering-Unterschiede zeigt:

```bash
node .claude/tools/svg-to-png.js [--scale=N] <datei.svg> ...
```

**Beispiele**:
```bash
node .claude/tools/svg-to-png.js abhandlungen/carnet-web-facharchitektur/fig-statusmodell.svg
node .claude/tools/svg-to-png.js --scale=3 abhandlungen/suchmaschinenwahl-partnerverzeichnis/fig-architektur.svg
```

Erfordert Chromium unter `~/.cache/ms-playwright/` oder `CHROMIUM_PATH`-Umgebungsvariable.

---

## Regeln

- **[EAQ-5]** Nur die Ziel-PNG-Dateien schreiben. SVG-Dateien nicht anfassen.
- **[EAQ-15]** PNG-Erstellung ist Pflicht nach jeder SVG-Erstellung oder -Änderung. PNG wird committed.
