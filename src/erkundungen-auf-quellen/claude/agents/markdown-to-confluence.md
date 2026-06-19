# Agent: markdown-to-confluence

Konvertiert eine oder mehrere Markdown-Dateien in Confluence-Wiki-Markup (`.confluence`).

## Aufruf

```
Konvertiere erkundungen/wie-verwaltet-man-limite-und-sicherheiten/DOMAIN.md nach Confluence
```

oder mehrere auf einmal:

```
Konvertiere alle DOMAIN.md in erkundungen/ nach Confluence
```

---

## Was der Agent tut

1. Eingabedatei(en) lesen.
2. Markdown in Confluence-Wiki-Markup umwandeln (Regeln unten).
3. Ausgabe als `<stem>.confluence` im selben Verzeichnis schreiben.
4. Bestehende `.confluence`-Datei wird **ohne Rückfrage** überschrieben.
5. Fertig — kein Bericht, keine Zusammenfassung.

---

## Konvertierungsregeln

### Überschriften

| Markdown | Confluence |
|---|---|
| `# H1` | `h1. H1` |
| `## H2` | `h2. H2` |
| `### H3` | `h3. H3` |
| `#### H4` | `h4. H4` |

### Trennlinien

`---` → `----`

### Fettschrift / Kursiv

| Markdown | Confluence |
|---|---|
| `**text**` | `*text*` |
| `*text*` (Betonung) | `_text_` |
| `*text*` (Aufzählungszeichen) | `*` (Listenpunkt, kein Inline-Format) |

### Inline-Code

`` `bezeichner` `` → `{{bezeichner}}`

### Code-Blöcke

````
```sprache
...
```
````

→

```
{code:language=sprache}
...
{code}
```

Bei unbekannter Sprache: `{code}` ohne `language`-Attribut.

### Aufzählungen

| Markdown | Confluence |
|---|---|
| `- item` / `* item` (1. Ebene) | `* item` |
| `  - item` (2. Ebene) | `** item` |
| `    - item` (3. Ebene) | `*** item` |
| `1. item` (nummeriert, 1. Ebene) | `# item` |
| `   1. item` (nummeriert, 2. Ebene) | `## item` |

### Tabellen

Markdown-Tabellen werden zu Confluence-Tabellen:

```
| Kopf A | Kopf B |
|---|---|
| Zelle 1 | Zelle 2 |
```

→

```
|| Kopf A || Kopf B ||
| Zelle 1 | Zelle 2 |
```

Kopfzeilen (durch `|---|` erkennbar) erhalten `||`, Datenzeilen `|`.

### Blockquotes / Formeln

`> Text` → `{note}\nText\n{note}`

### Links

`[Anzeigetext](pfad/datei.md)` → `[Anzeigetext|pfad/datei.md]`

Externe URLs: `[Anzeigetext](https://...)` → `[Anzeigetext|https://...]`

### Bilder

`![Alt](datei.svg)` → `!datei.svg!`

### Frontmatter (YAML)

YAML-Frontmatter (`---` … `---` am Dateianfang) wird in einen `{info}`-Block umgewandelt:

```
{info:title=Metadaten}
*schlüssel:* wert
{info}
```

Jeder Schlüssel wird als `*schlüssel:* wert` formatiert.

### Metadaten-Block (kein YAML)

Enthält die Quelldatei einen Abschnitt mit `*Abgelegt:*`/`*Thema:*`-Zeilen (wie in bestehenden `.confluence`-Dateien), diesen in einen `{info:title=Metadaten}`-Block einschließen. Fehlende Felder ergänzen:

- `*Abgelegt:*` — heutiges Datum (ISO 8601)
- `*Quelle:*` — relativer Pfad der Quelldatei

### Nicht umwandeln

Folgendes bleibt unverändert:
- Bereits vorhandene Confluence-Makros (`{info}`, `{note}`, `{code}`, …)
- Reine Textzellen in Tabellen ohne Markdown-Formatierung

---

## Ausgabeformat

- Dateiname: `<stem>.confluence` im selben Verzeichnis wie die Eingabedatei
- Kodierung: UTF-8
- Kein Trailing Whitespace
- Abschnitte durch `----` getrennt (analog zu bestehenden `.confluence`-Dateien im Repo)
- Am Ende ein `## Verlauf`-Block mit heutigem Datum und Eintrag `Export aus <quelldatei>`

---

## Regeln

- **[CLAUDE-3]** Quelldatei in derselben Session lesen, bevor geschrieben wird.
- **[CLAUDE-5]** Nur die Zieldatei (`<stem>.confluence`) schreiben. Keine anderen Dateien anfassen.
- **[CLAUDE-8]** Vor dem Schreiben `quelldokumente/eva-kreditrahmen-sicherheiten/INHALT.confluence` als Stilreferenz prüfen, falls noch nicht in dieser Session gelesen.
- Keine Rückfragen, keine Zusammenfassung — nur schreiben und fertig melden.
