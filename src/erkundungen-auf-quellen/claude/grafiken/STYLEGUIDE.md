# SVG-Styleguide

Verbindliche Vorgaben für alle SVG-Diagramme in diesem Repository.  
Vor jeder neuen SVG-Datei muss dieser Styleguide **und** [`vorlage.svg`](vorlage.svg) gelesen worden sein (CLAUDE-3, CLAUDE-15).

---

## Schrift

```
font-family="system-ui, -apple-system, 'Segoe UI', Arial, sans-serif"
```

Code- und Pfadangaben:
```
font-family="'Cascadia Code', 'Courier New', monospace"
```

---

## Farbpalette

| Rolle | Hex | Verwendung |
|---|---|---|
| Primär | `#007a99` | Hauptboxen, Header-Balken, Pfeile auf primären Pfaden |
| Primär dunkel | `#005f73` | Abschnittsüberschriften, tiefe Header |
| Primär hell | `#e0f4f8` | Box-Hintergründe (Primärbereich) |
| Akzent Orange | `#e07b00` | POST-Methoden, Warnungen, Schreib-Operationen |
| Akzent Orange hell | `#fff8ee` | Box-Hintergründe (Orange-Bereich) |
| Erfolg Grün | `#27ae60` | GET-Methoden, positive Zustände |
| Erfolg hell | `#f0fff4` | Box-Hintergründe (Grün-Bereich) |
| Fehler Rot | `#c0392b` | Fehler, destruktive Operationen, Schreib-Pfeile |
| Text primär | `#1a1a2e` | Hauptbeschriftungen |
| Text sekundär | `#444` | Beschreibungen, Details |
| Text tertiär | `#888` | Labels, Hinweise, deaktivierte Inhalte |
| Trennlinie | `#ddd` | Box-Borders, Divider |
| Hintergrund | `#f4f8fb` | Globaler Hintergrund |
| Weiß | `#ffffff` | Box-Inhaltsbereich, Karten |

---

## Geometrie

| Eigenschaft | Wert |
|---|---|
| Box-Radius | `rx="6"` (klein/inline), `rx="8"` (Hauptkarte) |
| Border-Stärke (Hauptbox) | `stroke-width="1.5"` |
| Border-Stärke (Divider) | `stroke-width="1"` |
| Pfeil-Stärke | `stroke-width="1.5"` |
| Gestrichelt | `stroke-dasharray="5,3"` |

---

## Typografie

| Klasse | Größe | Gewicht | Farbe | Verwendung |
|---|---|---|---|---|
| `.title` | 18–22px | bold | `#ffffff` | Header-Titel |
| `.subtitle` | 12–13px | normal | `#e0f4f8` | Header-Untertitel |
| `.section-title` | 14–15px | bold | `#007a99` | Abschnittsüberschriften |
| `.label` | 9–10px | normal | `#666` | Feldgruppen-Label (GROSSBUCHSTABEN) |
| `.body` | 11–13px | normal | `#444` | Fließtext, Beschreibungen |
| `.code` | 10–11px | normal | `#1a1a2e` | Pfade, Code, Feldnamen |
| `.badge` | 9–10px | bold | `#ffffff` | Methoden-Badges (GET, POST) |
| `.hint` | 9–10px | normal | `#888` | Hinweise, Anmerkungen |

---

## Pfeil-Marker

Drei Standard-Marker — immer aus [`vorlage.svg`](vorlage.svg) kopieren:

| ID | Farbe | Verwendung |
|---|---|---|
| `arrow-primary` | `#007a99` | Hauptpfade, Anfragen |
| `arrow-neutral` | `#555` | Neutrale Flüsse |
| `arrow-red` | `#c0392b` | Fehler, Schreib-Operationen |

---

## Struktur

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 W H"
     font-family="system-ui, -apple-system, 'Segoe UI', Arial, sans-serif">
  <defs>
    <!-- Marker aus vorlage.svg -->
    <style>
      /* CSS-Klassen aus vorlage.svg */
    </style>
  </defs>

  <!-- Globaler Hintergrund -->
  <rect width="W" height="H" fill="#f4f8fb"/>

  <!-- Inhalte -->
</svg>
```

**Reihenfolge in `<defs>`**: zuerst `<marker>`, dann `<style>`.  
`viewBox` immer gesetzt, `width`/`height` nur wenn explizit für Inline-Einbettung benötigt.

---

## Verlauf

- 2026-05-28 — Erstfassung, abgeleitet aus `ataswiss-api-overview.svg` und `kontext-diagramm.svg`
