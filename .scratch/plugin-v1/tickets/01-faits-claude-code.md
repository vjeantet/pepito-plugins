---
type: research
status: open
assignee:
blocked_by: []
triage: needs-triage
---

# 01: Faits Claude Code à vérifier

Carte : [../map.md](../map.md). Point de départ : [../research/faits-claude-code.md](../research/faits-claude-code.md) (documentation lue le 2026-10-25 via WebFetch, CLI 2.1.310 sans pepito).

## Question

Confirmer sur la page source, puis sur le Mac de l'utilisateur avec pepito lancé et connecté (`claude mcp add --scope user pepito -- <relais>`), les faits dont dépendent les tickets 02 à 08 :

- **Plugins** : schémas de `marketplace.json` et `plugin.json` tels que relevés ; `claude plugin validate` sur le dépôt (déjà vert, avertissements `version` et icône).
- **Skill en `-p`** : `claude -p "/pepito:<skill> <args>"` développe-t-il un skill de plugin installé, avec ses arguments (`$ARGUMENTS`) ? Avec un skill factice installé par `--plugin-dir`.
- **`allowed-tools` dans le frontmatter** : un skill de plugin qui déclare `allowed-tools: mcp__pepito__get_recording` peut-il l'appeler en `-p` sans `--allowedTools` ? La permission tombe-t-elle au message suivant comme le dit la documentation ? Accepte-t-il un motif (`mcp__pepito__*`) ?
- **`--tools ""`** : retire les outils intégrés et laisse les tools MCP (documenté) ; `--disallowedTools "mcp__*"` les retire ; vérifier qu'un `claude -p … --tools "" --allowedTools "mcp__pepito__*"` lit un Enregistrement et ne peut pas lancer de shell.
- **Serveur MCP déclaré par un plugin** :
  - nom des tools (`mcp__plugin_pepito_<serveur>__<tool>`) ;
  - doublon : avec la même commande que la déclaration utilisateur, le serveur du plugin est-il écarté (doublon par endpoint) ? Avec une autre commande (pepito dans `~/Applications`), deux Connexions MCP coexistent-elles, visibles dans Settings > MCP de pepito ?
  - commande au chemin absolu hors du plugin (`/Applications/pepito.app/Contents/Helpers/pepito-mcp`) : acceptée, refusée, avertie par `claude plugin validate` ?
- **Enfant de pepito** : un `claude -p` lancé par un processus enfant de pepito (simulé par un shell lancé depuis un terminal en attendant le Script de post-traitement) joint-il pepito par le Relais MCP ? Question partagée avec `script-post-traitement#08`.
- **Installation et mise à jour** depuis ce dépôt public : `/plugin marketplace add vjeantet/pepito-plugins`, `/plugin install pepito@pepito-plugins`, mise à jour automatique désactivée par défaut, détection d'un commit sans `version`.
- **`claude plugin eval`** (2.1.310) : utilisable pour tester les skills contre un pepito réel ou un faux serveur MCP ?

Livrable : compléter `research/faits-claude-code.md` (marqueur [V] vérifié, version de Claude Code, date) et lister ce qui change pour les tickets 02, 03, 07 et 08.

Skill : `research`. HITL : essais sur le Mac de l'utilisateur (pepito lancé, MCP activé).
