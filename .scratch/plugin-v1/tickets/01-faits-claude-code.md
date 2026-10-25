---
type: research
status: closed
assignee: claude
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

## Resolution

2026-10-25 : fiche [../research/faits-claude-code.md](../research/faits-claude-code.md) réécrite. Documentation relue en Markdown brut (citations exactes : [../research/verification-doc-2026-10-25.md](../research/verification-doc-2026-10-25.md)), essais sur Claude Code 2.1.310 avec un faux serveur MCP « pepito » ([../research/banc-essai/](../research/banc-essai/)). Les essais qui exigent le vrai pepito passent au ticket [11](11-essais-mac-pepito.md).

Faits établis :

1. **Skill en `-p`** : `claude -p "/pepito:<skill> <id>"` développe le skill d'un plugin et lui passe l'argument [D] [L].
2. **`allowed-tools`** d'un skill de plugin, nom exact ou `mcp__pepito__*`, suffit à permettre l'appel MCP en `-p`, sans `--allowedTools`, y compris pour un plugin installé depuis une marketplace ; sans lui, l'appel est refusé et listé dans `permission_denials` [L]. La documentation ne le dit que pour les skills de projet.
3. **`--tools ""`** retire les outils intégrés, garde les tools MCP et le développement du skill [D] [L] ; `--disallowedTools "mcp__*"` retire les tools MCP ; `--permission-mode dontAsk`, `--permission-prompts none` et `--max-turns` (documenté, absent de `--help`) existent [D].
4. **Serveur déclaré par un plugin** : tools `mcp__plugin_pepito_pepito__*` ; commande au chemin absolu hors du plugin acceptée sans avertissement ; commande absente = serveur `failed`, session poursuivie [L].
5. **Doublon** : un serveur de plugin n'est écarté que si sa commande **et ses `args`** sont ceux d'un serveur déclaré au-dessus (l'`env` ne compte pas) ; sinon deux serveurs et chaque tool en double sous `mcp__pepito__*` et `mcp__plugin_pepito_pepito__*` [D] [L]. **Corrige** le fait noté dans pepito le 2026-10-25 (« la déclaration utilisateur l'emporte » sans condition).
6. **Installation** depuis ce dépôt : `pepito@pepito-plugins` s'installe ; sans `version`, la version est le SHA court du dernier commit **du dépôt**, et tout commit, même limité à `.scratch/`, est livré comme mise à jour ; avec `version`, rien n'est livré sans hausse [D] [L]. Mise à jour automatique désactivée par défaut, et jamais déclenchée par un `claude -p` [D].
7. **`--bare`** ignore plugins et serveurs MCP découverts, et doit devenir le défaut de `-p` dans une version future [D] : risque pour un Script de post-traitement qui compte sur le plugin installé.

Conséquences pour les tickets :

- 02 : déclarer le serveur dans le plugin n'est sans doublon que si la commande est exactement celle de l'Assistant de connexion, ce qui dépend de l'emplacement de pepito ; sinon tools en double.
- 03 : `allowed-tools` porte des noms préfixés ; un tool renommé dans pepito devient refusé en `-p`, avec trace dans `permission_denials`.
- 07 : les skills peuvent porter eux-mêmes leurs permissions MCP ; l'appel peut se limiter à `--tools ""` ; ajouter `--permission-mode dontAsk` ou `--permission-prompts none`, `--max-turns`, et prévoir `--bare` (`--plugin-dir`, `--mcp-config`).
- 08 : sans `version`, chaque commit de documentation ou de `.scratch/` atteint les utilisateurs ; argument pour poser `version` dans `plugin.json`.
