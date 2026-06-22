#!/bin/bash
set -e
. dev-container-features-test-lib

CFG="$HOME/.config/opencode/config.json"

check "opencode cli installed" which opencode
check "config file exists" test -f "$CFG"
check "config is valid json" jq empty "$CFG"
check "model field is set" bash -c "jq -e '.model | length > 0' '$CFG' >/dev/null"
check "configured model registered in provider" bash -c "
  provider=\$(jq -r '.model' '$CFG' | cut -d'/' -f1)
  model_id=\$(jq -r '.model' '$CFG' | cut -d'/' -f2-)
  jq -e --arg p \"\$provider\" --arg m \"\$model_id\" '.provider[\$p].models[\$m]' '$CFG' >/dev/null
"

reportResults
