---
type: grilling
status: open
assignee:
blocked_by: [01]
triage: needs-triage
---

# 02: Déclarer ou non le serveur MCP dans le plugin

Carte : [../map.md](../map.md).

## Question

Proposition de départ (2026-10-25, pas une décision) : en v1, le plugin ne déclare pas le serveur MCP dans un `.mcp.json`. Il suppose le MCP connecté par l'Assistant de connexion de pepito (`claude mcp add --scope user pepito -- <relais>`), et ses skills nomment les tools par leur Nom de base (`get_recording`), sans préfixe.

- **Ne pas déclarer** :
  - une seule voie d'installation, celle que pepito documente et dont il affiche la Connexion MCP ; pas de doublon possible ;
  - prérequis à expliquer dans le README ; un skill doit reconnaître l'absence du serveur (aucun tool `get_recording` visible) et le dire en une phrase, sans tenter de connexion ;
  - noms en `-p` : `--allowedTools "mcp__pepito__*"` suppose que l'utilisateur a nommé le serveur `pepito`, nom imposé par la commande copiée de l'Assistant, mais modifiable à la main.
- **Déclarer** (`.mcp.json` du plugin, serveur `pepito`) :
  - installation en un geste de plus pour qui n'a pas connecté pepito ;
  - la commande serait un chemin absolu hors du plugin, non documenté par Claude Code (ticket 01) ;
  - `/Applications/pepito.app/…` en dur casse pour une app dans `~/Applications`, que pepito couvre (`serveur-mcp-v1.md` § 4, chemin calculé depuis `Bundle.main.bundleURL`) ; pepito a écarté le chemin absolu vers l'app pour l'Extension `.mcpb` pour cette raison (§ 8.3 [T11]) ;
  - doublon : d'après la documentation lue le 2026-10-25, le serveur du plugin n'est écarté que s'il a la même commande que la déclaration utilisateur ; sinon deux Connexions MCP et des tools en double sous `mcp__pepito__*` et `mcp__plugin_pepito_pepito__*` (à vérifier, ticket 01). Cela contredit le fait noté dans pepito le 2026-10-25 (« la déclaration utilisateur l'emporte »).
  - pepito montre l'Assistant de connexion comme la voie de connexion ; un plugin qui connecte lui-même n'enfreint pas [T07] (c'est l'utilisateur qui installe le plugin), mais ajoute une voie que pepito ne connaît pas : le dire dans pepito si elle est retenue.
- **Nommage dans les skills** : Nom de base (le LLM retrouve le tool quel que soit le préfixe), nom préfixé `mcp__pepito__…` (nécessaire dans `allowed-tools` et `--allowedTools`), ou les deux (Nom de base dans le texte, préfixé dans le frontmatter) ?
- **Absence du serveur** : texte du message, renvoi vers le README ; même règle en `-p`, où personne ne lit la réponse (code de sortie, sortie JSON) ?
- **Autres serveurs MCP de l'utilisateur** (calendrier, tickets, messagerie) : le plugin les suppose-t-il, les nomme-t-il ? Lien avec le ticket 04.

Skill : `grilling`. HITL : réponses de l'utilisateur seulement.
