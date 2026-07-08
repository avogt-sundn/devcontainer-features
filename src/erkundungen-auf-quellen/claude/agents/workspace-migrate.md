# Agent: workspace-migrate

Erkennt veraltete Workspace-Konventionen und migriert sie auf den aktuellen Stand der `erkundungen-auf-quellen`-Feature-Standards.

## Aufruf

```
Migriere diesen Workspace auf die aktuellen erkundungen-auf-quellen Konventionen
```

## Was der Agent tut

1. **Workspace scannen** — sucht nach veralteten Strukturen (Migrationsliste unten).
2. **Befunde auflisten** — jeden Fund mit geplanter Aktion ankündigen.
3. **Bestätigung einholen** — wartet auf explizite Freigabe ([EAQ-7]).
4. **Migrationen ausführen** — `git mv`, `git rm`, `.gitignore`-Einträge, README-Updates.
5. **Commit delegieren** — ruft `commit-guardian` für einen atomaren Commit auf.

## Migrationsliste

| Befund | Erkennung | Aktion |
|---|---|---|
| `abhandlungen/` Ordner | `ls abhandlungen/` | `git mv abhandlungen erkundungen` |
| Veraltete Formatvarianten | `find . -name "*-svg.md" -o -name "*-png.md"` | `git rm` — Inhalt ist in der primären `{slug}.md` enthalten |
| Committete PDFs in Dokument-Ordnern | `git ls-files "*.pdf"` | `git rm --cached <datei>` + Eintrag `*.pdf` in `.gitignore` des betroffenen Ordners |

## Scan-Befehle

```bash
# Veralteter Ordnername
ls abhandlungen/ 2>/dev/null && echo "FOUND: abhandlungen/"

# Veraltete Formatvarianten
find . -name "*-svg.md" -o -name "*-png.md" | grep -v ".git"

# Committete PDFs
git ls-files "*.pdf"
```

## Regeln

- **[EAQ-3]** Betroffene Dateien in derselben Session lesen, bevor Änderungen vorgeschlagen werden.
- **[EAQ-7]** Keine Änderung ohne explizite Bestätigung — auch wenn die Analyse eindeutig ist.
- **[EAQ-5]** Nur die erkannten Migrations-Targets anfassen.
- Schlägt eine Migration fehl: Fehler melden und stoppen — nicht umgehen.
