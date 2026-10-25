---
type: grilling
status: open
assignee:
blocked_by: []
triage: needs-info
---

# 06: Skill `prepare-meeting`

Carte : [../map.md](../map.md).

## Question

Préparer une réunion à venir : retrouver les Enregistrements passés qui s'y rapportent (mêmes participants, même sujet, mêmes Tags) et en tirer une préparation.

Bloqué côté pepito (constat du 2026-10-25, `script-post-traitement/map.md` de pepito, Out of scope) :

- aucun tool MCP ne lit le calendrier : les Événements ne sont visibles que rattachés à un Enregistrement existant (`get_recording`) ;
- aucun objet ne peut recevoir une préparation tant que l'Enregistrement n'existe pas : `append_notes` et `add_artifact` visent un `id`, qui n'apparaît qu'au démarrage de la Session.

Questions à reprendre quand pepito aura tranché :

- Source de la réunion à venir : tool calendrier de pepito, autre serveur MCP de calendrier de l'utilisateur, ou titre et participants donnés par l'utilisateur ? La dernière option se passe de pepito pour l'entrée et ne lève que le premier blocage.
- Destination de la préparation : un objet de pepito avant l'Enregistrement (à créer dans pepito), le début des Notes de la Session une fois démarrée (`session-companion`, ticket 05), ou un document hors de pepito ?
- Recherche des Enregistrements liés : `list_recordings` (`query` sur Titre, Tags, Participants, sans plein texte, `serveur-mcp-v1.md` § 6.3), puis `get_summary` et `get_notes`.

## Dépendances hors chantier

- pepito : tool de lecture du calendrier et objet de préparation. Aucun chantier ouvert dans pepito au 2026-10-25 ; à proposer par l'utilisateur dans pepito.

Skill : `grilling`, une fois les informations obtenues. HITL : décision de l'utilisateur dans pepito.
