#!/bin/bash
# Lance un essai `claude -p` isolé et résume la sortie JSON.
# usage : LAB=<dossier de travail> [CFG=<CLAUDE_CONFIG_DIR>] run.sh <label> <prompt> [options claude…]
# Les journaux du faux serveur vont dans $LAB/logs, les sorties dans $LAB/out.
set -u
LAB=${LAB:?LAB requis}; label=$1; prompt=$2; shift 2
mkdir -p "$LAB/work" "$LAB/out" "$LAB/logs"; cd "$LAB/work" || exit 1
CLAUDE_CONFIG_DIR=${CFG:-$HOME/.claude} FAKE_LOG_DIR=$LAB/logs \
  env -u CLAUDE_CODE_SESSION_ID -u CLAUDE_CODE_REMOTE_SESSION_ID \
  timeout 240 claude -p "$prompt" --model haiku --output-format json --no-session-persistence "$@" \
  > "$LAB/out/$label.json" 2> "$LAB/out/$label.err"
echo "== $label exit=$?"
python3 -I - "$LAB/out/$label.json" <<'PY'
import json, sys
try:
    d = json.load(open(sys.argv[1]))
except Exception:
    print("unparsable:", open(sys.argv[1]).read()[:400]); sys.exit()
print("result:", (d.get("result") or "")[:400].replace("\n", " | "))
print("denials:", json.dumps(d.get("permission_denials"))[:400], "turns:", d.get("num_turns"))
PY
