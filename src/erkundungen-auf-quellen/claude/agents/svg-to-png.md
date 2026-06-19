# Agent: svg-to-png

Wandelt SVG-Dateien in PNG-Rastergrafiken um — für Confluence-Uploads, Präsentationen oder Dokumentenexport.

## Aufruf

```
Konvertiere erkundungen/wie-sieht-ein-agentischer-arbeitsalltag-aus/grafiken/*.svg nach PNG
```

oder einzeln:

```
Konvertiere grafiken/posteingang.svg nach PNG mit 3-facher Auflösung
```

---

## Was der Agent tut

1. SVG-Dateien identifizieren (Shell-Glob oder einzelne Pfade).
2. Tool aufrufen: `node .claude/tools/svg-to-png.js [--scale=N] <datei.svg> ...`
3. PNG landet im selben Verzeichnis wie das SVG — Dateiname identisch (`.svg` → `.png`).
4. Ausgabe: Dateiname, Pixelgröße, Skalierungsfaktor.

---

## Tool-Aufruf

```bash
node .claude/tools/svg-to-png.js [--scale=N] <datei.svg> ...
```

**Beispiele**:
```bash
# Einzelne Datei (Standardauflösung 2x)
node .claude/tools/svg-to-png.js erkundungen/wie-sieht-ein-agentischer-arbeitsalltag-aus/grafiken/posteingang.svg

# Ganzer Ordner via Shell-Glob
node .claude/tools/svg-to-png.js erkundungen/wie-sieht-ein-agentischer-arbeitsalltag-aus/grafiken/*.svg

# 3-fache Auflösung
node .claude/tools/svg-to-png.js --scale=3 grafiken/agenten-workflow.svg
```

---

## Voraussetzungen (durch DevContainer eingerichtet)

| Was | Status |
|---|---|
| `libcairo2`, `libpango-1.0-0`, `libcups2`, `libatk-bridge2.0-0` u. a. | `postCreate-playwright-deps.sh` via apt |
| `playwright-core` | `postCreate-playwright-deps.sh` via `npm install` in `.claude/tools/` |
| Chromium | `~/.cache/ms-playwright/chromium-*/chrome-linux/chrome` — automatisch gefunden |

Chromium-Pfad überschreibbar per `CHROMIUM_PATH`-Umgebungsvariable.

---

## Ausgabe

- `<stem>.png` im selben Verzeichnis wie `<stem>.svg`
- Standard: `--scale=2` (Retina/HiDPI, 2× CSS-Pixel)
- Pixelgröße = SVG-Viewport × Skalierungsfaktor

---

## Regeln

- **[CLAUDE-5]** Nur die Ziel-PNG-Dateien schreiben. SVG-Dateien nicht anfassen.
- **[CLAUDE-14]** Skalierungsfaktor immer nennen, wenn er vom Standard (2) abweicht.
