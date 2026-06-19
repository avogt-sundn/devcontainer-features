# Axiome — Arbeitsweise mit Claude

Übergreifende Regeln für jeden Agenten und jede Änderung.

- **[EAQ-1] Klarheit und Kürze.** Kein Padding, keine Redundanz, kein Fülltext. Jede Zeile muss ihren Platz verdienen.
- **[EAQ-2] Lokalität und Hierarchie.** Jede Zeile lebt so nah wie möglich an ihrem Verwendungsort. Belange werden in einer strikten Hierarchie getrennt.
- **[EAQ-3] Lesen vor Schreiben.** Vor jeder Dateiänderung muss die aktuelle Version in derselben Session gelesen worden sein. Schreiben aus dem Gedächtnis oder aus einer anderen Session ist verboten.
- **[EAQ-4] Ergebnisse verifizieren, nicht Absichten.** Eine Aufgabe ist erledigt, wenn die Änderung nachweislich funktioniert — nicht wenn der Code geschrieben wurde.
- **[EAQ-5] Minimaler Fußabdruck.** Nur das Explizit-Beauftragte ändern. Kein opportunistisches Refactoring, kein Cleanup, keine präventiven Ergänzungen. Beobachtete Probleme melden, nicht still beheben.
- **[EAQ-6] Jeden stillen Standard vor dem Handeln benennen.** Wenn der Agent einen Pfad, Port, Typ oder Namenskonvention ergänzt, die nicht explizit vorgegeben wurde, muss er das vor dem Schreiben deklarieren.
- **[EAQ-7] Explizite Bestätigung vor irreversiblen Aktionen.** Alles, was nicht durch ein einfaches `git revert` rückgängig gemacht werden kann, erfordert eine explizite Bestätigung.
- **[EAQ-8] Vor dem Erfinden replizieren.** Bevor Code, Konfiguration oder Dokumentation produziert wird, das nächste passende Beispiel im Repository suchen und dessen Struktur, Benennung und Stil übernehmen.
- **[EAQ-9] Jede Domäne dokumentiert sich selbst.** Jeder Domänen-Ordner enthält eine `DOMAIN.md` mit Zweck, Bounded Context und Schlüsselentscheidungen.
- **[EAQ-10] Ubiquitäre Sprache — Glossarbegriffe sind erstklassige Code-Identifier.** Code ist standardmäßig Englisch. Ausnahme: Fachbegriffe, die im Projekt-Glossar (Wahrheitsquelle) oder im `## Glossar`-Abschnitt einer `DOMAIN.md` (Auszug) dokumentiert sind, sind die *einzig zulässige* Form für dieses Konzept im Code dieser Domäne — niemals ins Englische übersetzen.
- **[EAQ-11] Ordner-Closure.** Bei Aufgaben, die auf einen Ordner `F` begrenzt sind: (1) alle Dateioperationen auf `F` und seine Nachkommen beschränken; (2) nur `.md`-Steuerdateien in `F` und dessen Vorfahren bis zum Repo-Root befolgen; (3) keine Regel eines Nachfahren überschreibt eine Regel eines Vorfahren.
- **[EAQ-12] Sub-Agent-Delegation vor dem Aufruf ankündigen.** Orchestrierende Agenten müssen jeden Sub-Agenten und dessen Begründung nennen, bevor sie ihn aufrufen.
- **[EAQ-13] Wissenskarte vor jeder Scoped-Arbeit traversieren.** Vor jeder Ausgabe für eine Domäne, einen Ordner oder ein Ticket in dieser Reihenfolge lesen: (1) `CLAUDE.md`, (2) relevante Agent-Dateien aus `.claude/agents/`, (3) `<domäne>/DOMAIN.md`. Partielle Traversierung gilt nicht.
- **[EAQ-14] Geltende Regel für jede nicht-triviale Entscheidung nennen.** Bei der Wahl zwischen gültigen Optionen — Benennung, Ansatz, Architektur, Strategie — muss der Agent benennen, welches Axiom, welche Konvention oder welches bestehende Muster diese Wahl begründet. Stille Standards sind verboten; jeder sichtbare Entscheidungspunkt muss seine Begründung tragen.
- **[EAQ-15] Diagramme immer als SVG — Styleguide und Vorlage zwingend.** Jedes Diagramm, jede Skizze und jedes Schema wird als `.svg`-Datei angelegt und per `![Titel](datei.svg)` verlinkt. ASCII-Grafiken in Codeblöcken sind verboten — auch als Entwurf. Vor jeder neuen SVG müssen `~/.claude/grafiken/STYLEGUIDE.md` und `~/.claude/grafiken/vorlage.svg` in derselben Session gelesen worden sein; die `<defs>` (Marker + CSS-Klassen) aus der Vorlage sind Ausgangspunkt jeder SVG.

---

## Konventionen

**Domänendokumentation**: Jeder Domänen-Ordner enthält eine `DOMAIN.md` mit Zweck, Bounded Context und Schlüsselentscheidungen.

**Entwicklungsweg sichtbar halten**: Arbeitsdateien werden nie überschrieben — der Erkenntnisweg bleibt Teil des Dokuments.

- **Kleine Änderungen** — `## Verlauf`-Abschnitt am Dateiende fortschreiben:
  ```markdown
  ## Verlauf
  - 2026-05-22 — Erstfassung
  - 2026-05-23 — These 3 überarbeitet
  ```
- **Größere Umbrüche** — neue Version als datierten Abschnitt anhängen, alte Version stehen lassen:
  ```markdown
  ## These — 2026-05-15
  ...ursprünglicher Text...

  ## These — 2026-05-22 (überarbeitet)
  ...neue Version...
  ```

Git fängt den Rest auf.
