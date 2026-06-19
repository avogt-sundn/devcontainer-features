# Agent: quelldokumente-eingang

Verarbeitet neue Quelldateien aus `quelldokumente/_eingang/` und legt sie strukturiert in `quelldokumente/` ab.

## Aufruf

```
Verarbeite den Eingang
```

---

## Was der Agent tut

### 1 — Inventar aufnehmen

Alle Dateien in `quelldokumente/_eingang/` auflisten. Dateiarten:

| Typ | Erkennung |
|-----|-----------|
| PDF | `*.pdf` |
| Word | `*.docx`, `*.doc` |
| Bild | `*.png`, `*.jpg`, `*.jpeg`, `*.svg` |
| Präsentation | `*.pptx`, `*.ppt` |
| Link-Liste | `links.txt` — eine URL pro Zeile |
| Sonstiges | alle anderen Dateien |

### 2 — Voranalyse pro Datei

Für jede Datei:

- **PDF**: Titelseite und erste Seiten lesen (`pdftotext` oder Python `pdfplumber`), Thema und Quelle ableiten.
- **Word/PPTX**: Dateiname und erkennbaren Inhalt auswerten.
- **Bild**: Dateiname auswerten und Bild mit dem `Read`-Tool öffnen — visuellen Inhalt vollständig erfassen (alle Texte, Tabellen, Beschriftungen).
- **links.txt**: Jede URL einzeln abrufen (`WebFetch`), Titel und Beschreibung extrahieren.

### 3 — Quell-Kandidaten gruppieren

Dateien, die erkennbar dieselbe Quelle sind (gleiche Publikation in verschiedenen Formaten, Folien + zugehöriges PDF etc.), werden als Gruppe behandelt und in **einen** gemeinsamen Zielordner gelegt.

### 4 — Zielordner-Namen vorschlagen

Namensschema: `kebab-case`, Deutsch, beschreibend, maximal 40 Zeichen.  
Beispiel: `erp-integration-pptx`, `digital-coo-zertifikat`.

Prüfen, ob ein passender Ordner in `quelldokumente/` bereits existiert — wenn ja, Dateien dort einsortieren statt neuen Ordner anlegen.

### 5 — Bericht an den Nutzer

Vor dem Verschieben einen kurzen Bericht ausgeben:

```
Gefundene Dateien:
  1. erp-overview.pdf  → quelldokumente/erp-overview/  (neuer Ordner)
  2. erp-overview.png  → quelldokumente/erp-overview/  (selbe Quelle wie 1)
  3. links.txt (3 URLs):
       https://...     → quelldokumente/ataswiss-blog/  (neuer Ordner, scrape als .md)
       https://...     → quelldokumente/erp-overview/   (passt zur Quelle 1)

Weiter? (ja / Korrekturen eingeben)
```

Der Nutzer kann Zielordner korrigieren oder einzelne Dateien überspringen.

### 6 — Ausführen

Nach Bestätigung:

1. Zielordner anlegen (falls neu).
2. Alle Dateien in den Zielordner **verschieben** (`mv`).
3. `INHALT.md` im Zielordner erstellen oder erweitern (siehe §7).
4. Für jede `links.txt`-URL: Inhalt via `WebFetch` abrufen, als Abschnitt in `INHALT.md` einfügen (kein separates Original).
5. `links.txt` aus `_eingang/` löschen.
6. `_eingang/` bleibt leer (nur `.gitkeep`).

### 7 — INHALT.md

Jeder Zielordner hat genau **eine** `INHALT.md` — der kanonische Einstiegspunkt für Erkundungen, vollständig maschinenlesbar ohne Zugriff auf Binärdateien.

**Struktur:**
```markdown
---
abgelegt: YYYY-MM-DD
thema: <ein Satz der den gesamten Ordnerinhalt beschreibt>
dateien:
  - dateiname: <name>
    typ: bild | pdf | praesentation | link | sonstiges
---

# <Titel der Quelle>

## <Dateiname oder URL>

<transkribierter Inhalt>

## <weitere Datei im selben Ordner>

<transkribierter Inhalt>
```

Existiert bereits eine `INHALT.md` (beim Einsortieren in einen bestehenden Ordner): neue Abschnitte **anhängen**, nichts überschreiben. `abgelegt` und `dateien` im Frontmatter ergänzen.

**Transkription je Dateityp:**

| Typ | Inhalt des Abschnitts |
|-----|-----------------------|
| **Bild** (PNG/JPG/SVG) | Vollständige Transkription aller sichtbaren Texte, Zahlen, Beschriftungen. Tabellen als Markdown-Tabellen. Abschließend `### Bildbeschreibung` mit visueller Einordnung (Layout, Herkunft, Kontext). |
| **PDF** | Inhaltsverzeichnis (falls vorhanden), Fließtext der Hauptseiten. Lange Dokumente: Überblick + vollständiger Text der ersten 5 Seiten + Zusammenfassung der restlichen Kapitel. |
| **PPTX** | Folientitel + Texte jeder Folie, gegliedert nach Foliennummer. |
| **Link** | Seitentitel, vollständiger Fließtext, Quelll-URL und Abrufdatum. |
| **Sonstiges** | Dateiname, erkennbarer Inhalt, Kurzbeschreibung. |

`INHALT.md` ersetzt **nicht** die Originaldateien — sie ist die maschinenlesbare Brücke zu `erkundungen/`. Originale bleiben im selben Ordner.

---

## Regeln

- **[EAQ-3]** Jede Quelldatei vor dem Verschieben lesen/analysieren — nie blind umbenennen.
- **[EAQ-5]** Nur `_eingang/` und `quelldokumente/` anfassen. Keine anderen Ordner.
- **[EAQ-7]** Immer Bericht + Bestätigung vor dem Verschieben — Verschieben ist nicht reversibel ohne `git`.
- Existierende Ordner in `quelldokumente/` bevorzugen: Nicht unnötig neue anlegen.
- Ordnernamen sind `kebab-case`, ohne Versionsnummern, ohne Datum.
