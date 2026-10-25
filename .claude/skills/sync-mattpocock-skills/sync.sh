#!/usr/bin/env bash
# Synchronise les skills de mattpocock/skills dans .claude/skills/.
#
# Usage : sync.sh [ref]
#   ref : commit, tag ou branche de mattpocock/skills. Par défaut, le commit
#         épinglé par le marketplace anthropics/claude-plugins-official.
#
# Seuls les skills listés dans le lock sont gérés : ils sont remplacés, ou
# supprimés s'ils ont disparu en amont. Un skill du projet qui porterait le nom
# d'un nouveau skill amont bloque la synchronisation.
set -euo pipefail

REPO_URL=https://github.com/mattpocock/skills.git
MARKETPLACE_URL=https://raw.githubusercontent.com/anthropics/claude-plugins-official/HEAD/.claude-plugin/marketplace.json

root=$(git rev-parse --show-toplevel)
dest="$root/.claude/skills"
lock="$dest/.mattpocock-skills.lock"

ref=${1:-}
if [[ -z $ref ]]; then
  ref=$(curl -fsSL "$MARKETPLACE_URL" | python3 -c '
import json, sys
p = next(p for p in json.load(sys.stdin)["plugins"] if p["name"] == "mattpocock-skills")
print(p["source"]["sha"])')
  echo "Commit épinglé par claude-plugins-official : $ref"
fi

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

git -C "$tmp" init -q
git -C "$tmp" fetch -q --depth 1 "$REPO_URL" "$ref"
git -C "$tmp" checkout -q FETCH_HEAD
commit=$(git -C "$tmp" rev-parse HEAD)

# Chemins des skills déclarés par le manifeste du plugin, puis version.
manifest=$(python3 -c '
import json, sys
m = json.load(open(sys.argv[1]))
print(m["version"])
for s in m["skills"]:
    print(s)' "$tmp/.claude-plugin/plugin.json")
version=$(head -1 <<<"$manifest")
paths=$(tail -n +2 <<<"$manifest")

new_names=()
while IFS= read -r p; do new_names+=("$(basename "$p")"); done <<<"$paths"

old_names=()
if [[ -f $lock ]]; then
  while read -r key value; do
    [[ $key == skill ]] && old_names+=("$value")
  done <"$lock"
else
  # Premier passage : les répertoires existants de même nom sont considérés comme gérés.
  for n in "${new_names[@]}"; do [[ -d $dest/$n ]] && old_names+=("$n"); done
fi

contains() { local x=$1; shift; for e in "$@"; do [[ $e == "$x" ]] && return 0; done; return 1; }

for n in "${new_names[@]}"; do
  if [[ -e $dest/$n ]] && ! contains "$n" "${old_names[@]+"${old_names[@]}"}"; then
    echo "Erreur : .claude/skills/$n existe et n'est pas géré par cette synchronisation." >&2
    exit 1
  fi
done

for n in "${old_names[@]+"${old_names[@]}"}"; do
  if ! contains "$n" "${new_names[@]}"; then
    rm -rf "${dest:?}/$n"
    echo "supprimé : $n"
  fi
done

while IFS= read -r p; do
  n=$(basename "$p")
  rm -rf "${dest:?}/$n"
  cp -R "$tmp/$p" "$dest/$n"
done <<<"$paths"
cp "$tmp/LICENSE" "$dest/LICENSE-mattpocock-skills"

{
  echo "# Généré par sync-mattpocock-skills, ne pas éditer."
  echo "commit $commit"
  echo "version $version"
  for n in "${new_names[@]}"; do echo "skill $n"; done
} >"$lock"

echo "mattpocock/skills $version ($commit) : ${#new_names[@]} skills synchronisés."
git -C "$root" status --short -- .claude/skills
