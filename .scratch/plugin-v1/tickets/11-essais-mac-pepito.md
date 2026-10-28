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

Avec pepito 26.58 ou plus récent lancé, MCP activé et Claude Code connecté par l'Assistant de connexion (`claude mcp add --transport http --scope user pepito <url> --header "Authorization: Bearer <jeton>"`) :

- **Noms réels** : `claude -p "List every tool name you have access to whose name starts with mcp__pepito"` rend les 19 tools de la référence du catalogue sous `mcp__pepito__*`.
- **Skill de plugin installé** : le skill `probe-wildcard` du [banc d'essai](../research/banc-essai/) (copié dans un plugin installé, ou par `--plugin-dir`) lit un vrai Enregistrement en `-p` avec `allowed-tools: mcp__pepito__*`, sans `--allowedTools`.
- **pepito absent au démarrage** : pepito quitté (ou MCP désactivé) avant `claude` : état du serveur dans `/mcp` et dans l'événement `init` de `-p` (`mcp_servers`), tools visibles, réponse d'un skill.
- **Connexion coupée** : pepito quitté puis relancé pendant une session interactive : Claude Code rouvre-t-il une session HTTP seul à la requête suivante (404 puis `initialize`, `serveur-mcp-v1.md` § 4), ou faut-il `/mcp` ? Réponse d'un skill appelé pendant que pepito est quitté.
- **Jeton régénéré ou port changé** : réponse de Claude Code au 401 (tentative OAuth, état `needs-auth`, échec simple ?) et au refus de connexion ; réponse d'un skill.
- **Enfant de pepito** : un `claude -p` lancé par un processus enfant de pepito joint-il le Point d'accès HTTP (configuration user lue, jeton compris) ? Sans Script de post-traitement, pas de moyen propre de le jouer : à faire avec le premier prototype de `script-post-traitement` dans pepito (question partagée avec `script-post-traitement#08`).

Retiré le 2026-10-27 : l'essai de **doublon** avec un `.mcp.json` de plugin. Le ticket [02](02-declaration-serveur-mcp.md) écarte toute déclaration en v1, et depuis 26.58 une déclaration demanderait le jeton de chaque utilisateur.

Livrable : compléter [../research/faits-claude-code.md](../research/faits-claude-code.md) (marqueur [Mac], version de Claude Code et de pepito, date).

## Dépendances hors chantier

- Le point « enfant de pepito » attend un prototype du Script de post-traitement dans pepito ; les autres points n'attendent rien.

Skill : `research`. HITL : essais sur le Mac de l'utilisateur.

## Comments

- 2026-10-27 (ticket [03](03-compatibilite-versions.md)) : questions réécrites pour le Point d'accès HTTP, qui remplace le Relais MCP depuis pepito 26.58. Les trois points « pepito absent », « connexion coupée » et « jeton régénéré » fixent la forme des messages du ticket 02 (point 5) et des remèdes du README.
- 2026-10-28 (ticket [04](04-process-recording.md)) : cas à ajouter pour `process-recording` : Enregistrement `completed` sans CR (refus) ; relance sur un Enregistrement déjà traité (bilan repéré) ; `claude -p` avec marqueur, `id` exact et `--tools ""` : Tags et bilan seuls, aucun Outil tiers ; CR ou Notes portant un texte qui s'adresse à l'agent (ignoré, signalé).
