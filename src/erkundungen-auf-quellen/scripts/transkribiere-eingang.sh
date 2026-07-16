#!/usr/bin/env bash
# Transkribiert MP4-Dateien aus quelldokumente/_eingang/ via Whisper-Server.
# Ergebnis: <dateiname>-transkript.md neben der Quelldatei.
# Verwendung:
#   bash scripts/transkribiere-eingang.sh                          # alle MP4s in _eingang/
#   bash scripts/transkribiere-eingang.sh quelldokumente/_eingang/datei.mp4
set -euo pipefail

EINGANG="quelldokumente/_eingang"
API="${WHISPER_API:-http://192.168.64.1:8765}"
ENDPUNKT="$API/v1/audio/transcriptions"

if [ $# -gt 0 ]; then
  FILES=("$@")
else
  mapfile -t FILES < <(find "$EINGANG" -maxdepth 1 -name "*.mp4" | sort)
fi

if [ ${#FILES[@]} -eq 0 ]; then
  echo "Keine MP4-Dateien in $EINGANG gefunden."
  exit 0
fi

for mp4 in "${FILES[@]}"; do
  ziel="${mp4%.mp4}-transkript.md"

  if [ -f "$ziel" ]; then
    echo "Übersprungen (Transkript existiert): $ziel"
    continue
  fi

  echo "Transkribiere: $mp4 ..."

  antwort=$(curl -sf "$ENDPUNKT" \
    -F "file=@$mp4" \
    -F "model=whisper-1" \
    -F "language=de" \
    -F "response_format=text")

  {
    echo "# Transkript — $(basename "$mp4")"
    echo ""
    echo "> Automatisch transkribiert via Whisper. Bitte bereinigen."
    echo ""
    echo "$antwort"
  } > "$ziel"

  echo "✓  $ziel"
done

echo ""
echo "${#FILES[@]} Datei(en) verarbeitet."
