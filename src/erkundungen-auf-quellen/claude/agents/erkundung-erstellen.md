# Agent: erkundung-erstellen

Legt eine neue Erkundung an — einen eigenständigen Denkraum zu einer Frage oder einem Thema, der als Markdown-Dokument mit optionalen SVG-Diagrammen versioniert wird.

## Wann diesen Agenten aufrufen

- Architekturentscheidung muss begründet und nachvollziehbar dokumentiert werden
- Benchmark-Ergebnisse oder Messdaten sollen als zitierfähiges Dokument festgehalten werden
- Stakeholder-Deliverable (Übergabe, Entscheidungsvorlage, Design-Grundlage)
- Offene Forschungsfrage soll vor einer Implementierungsentscheidung strukturiert beantwortet werden

## Aufruf

```
Lege eine neue Erkundung an: Elasticsearch vs. PostgreSQL für die Partnersuche
```

oder mit explizitem Slug:

```
Lege eine neue Erkundung an mit Slug: suchmaschinenwahl-partnerverzeichnis
```

---

## Ordnerkonvention

Eine Erkundung ist genau ein Ordner:

```
{container}/{slug}/
  {slug}.md       ← primäre Quelle — Markdown mit eingebetteten SVG-Referenzen
  fig*.svg        ← SVG-Assets (hand-authored, Styleguide beachten)
  fig*.png        ← PNG-Assets (abgeleitet via rsvg-convert, committed)
```

**PDF wird nicht committed** — es wird bei Bedarf erzeugt:
```bash
node .claude/tools/domain-to-pdf.js {slug}.md
```

**Slug-Konventionen:** Zwei gültige Formen:
- Thematisch (Noun-Phrase): `suchmaschinenwahl-partnerverzeichnis`, `carnet-web-facharchitektur`
- Frageform (Verb-Phrase): `wie-modelliert-man-das-datenmodell`, `welche-architektur-passt-zu-unserem-system`

Thematisch für Abhandlungen und Deliverables. Frageform für offene Erkundungen. Einmal gewählt, nicht nachträglich umbenennen.

---

## Was der Agent tut

1. **Slug festlegen** — aus Titel ableiten oder vom Nutzer übernehmen.
2. **Ordner anlegen** — `{container}/{slug}/`.
3. **`{slug}.md` erstellen** — Struktur:
   ```markdown
   # {Titel}

   `{container}/{slug}/` · {Projekt} · {Datum} · Vers. 1

   **Zusammenfassung.** Ein Satz.

   ---

   ## 1 {Erster Abschnitt}
   …
   ```
4. **Diagramme nach EAQ-15 wählen:**
   - ASCII: Tabellen, Bäume, einfache Strukturen
   - Mermaid `sequenceDiagram`: Mehrakteur-Abläufe
   - SVG: Architekturübersichten, Slidedeck-Qualität, >~12 Knoten → `STYLEGUIDE.md` und `vorlage.svg` lesen
5. **Nach jeder SVG:** `rsvg-convert -o fig-name.png fig-name.svg` ausführen und PNG committen.

---

## Regeln

- **[EAQ-5]** Nur die Zieldateien des neuen Dokuments schreiben. Kein opportunistisches Aufräumen.
- **[EAQ-8]** Bestehende Erkundung als Stilvorlage lesen, bevor die neue geschrieben wird.
- **[EAQ-15]** Diagrammformat nach Komplexität wählen — kein Format darf dasselbe Diagramm doppelt abbilden.
