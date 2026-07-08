# Erkundungen

Standalone-Dokumente zu Architektur-, Design- und Forschungsfragen dieses Projekts.
Authoring-Konventionen, Diagrammregeln (EAQ-15) und Werkzeuge werden durch das
DevContainer-Feature `erkundungen-auf-quellen` bereitgestellt.

## Ordnerkonvention

```
{slug}/
  {slug}.md     ← primäre Quelle (Markdown + inline SVG-Referenzen)
  fig*.svg      ← SVG-Assets (hand-authored, Styleguide beachten)
  fig*.png      ← PNG-Assets (abgeleitet via rsvg-convert, committed)
```

PDF auf Abruf: `node .claude/tools/domain-to-pdf.js {slug}.md`

## Inhalt

| Ordner | Beschreibung |
|---|---|
| *(noch leer)* | |
