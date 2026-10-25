---
type: research
status: open
assignee:
blocked_by: []
triage: ready-for-human
---

# 11: Essais sur le Mac avec pepito

Carte : [../map.md](../map.md). Reste du ticket [01](01-faits-claude-code.md), qui n'a pu être joué qu'avec un faux serveur MCP, sous Linux.

## Question

Avec pepito lancé, MCP activé et Claude Code connecté par l'Assistant de connexion (`claude mcp add --scope user pepito -- <relais>`) :

- **Noms réels** : `claude -p "List every tool name you have access to whose name starts with mcp__pepito"` rend les 19 tools de la référence du catalogue sous `mcp__pepito__*`.
- **Skill de plugin installé** : le skill `probe-wildcard` du [banc d'essai](../research/banc-essai/) (copié dans un plugin installé, ou par `--plugin-dir`) lit un vrai Enregistrement en `-p` avec `allowed-tools: mcp__pepito__*`, sans `--allowedTools`.
- **Doublon** : un plugin de test dont le `.mcp.json` déclare `pepito` avec la commande exacte de l'Assistant ; puis avec un autre chemin (copie de l'app, ou `~/Applications`). Dans chaque cas : tools visibles, et nombre de Connexions MCP dans Settings > MCP > Outils IA vus.
- **Enfant de pepito** : un `claude -p` lancé par un processus enfant de pepito joint-il pepito par le Relais MCP ? Sans Script de post-traitement, pas de moyen propre de le jouer : à faire avec le premier prototype de `script-post-traitement` dans pepito (question partagée avec `script-post-traitement#08`).
- **Connexion coupée** : pepito quitté puis relancé pendant une session interactive ; `/mcp` reconnecte-t-il ? Message d'un skill quand pepito est absent.

Livrable : compléter [../research/faits-claude-code.md](../research/faits-claude-code.md) (marqueur [Mac], version de Claude Code et de pepito, date).

## Dépendances hors chantier

- Le point « enfant de pepito » attend un prototype du Script de post-traitement dans pepito ; les autres points n'attendent rien.

Skill : `research`. HITL : essais sur le Mac de l'utilisateur.
