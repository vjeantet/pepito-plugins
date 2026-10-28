---
type: grilling
status: open
assignee:
blocked_by: []
triage: needs-triage
---

# 06: Skill `prepare-meeting`

Carte : [../map.md](../map.md).

## Question

Préparer une réunion à venir avant que son Enregistrement existe : retrouver les Enregistrements passés qui s'y rapportent, en tirer une préparation, et garder en attente dans la conversation les notes, Artefacts et Tags qui seront écrits au démarrage de la Session.

Conception retenue au ticket [05](05-session-companion.md) (2026-10-28, points 8 et 9), qui lève le blocage côté pepito noté le 2026-10-25 (aucun tool calendrier, aucun objet avant l'Enregistrement) :

- les quatre usages de `session-companion` sont possibles avant la Session : lecture du passé tout de suite ; notes, Artefacts et Tags gardés en attente dans la conversation ;
- `session-companion` propose cette préparation après confirmation quand aucune Session n'est en cours ; au démarrage, il rattache la Session après confirmation et écrit les éléments en attente d'un bloc (un `append_notes`, puis les `add_artifact`, un `update_tags`) ;
- le tool calendrier de pepito n'est plus requis.

Reste à trancher :

- **Source de la réunion** : description par l'utilisateur, Outil tiers de calendrier s'il en a un (aucun nommé), ou les deux ? Que faire d'un Événement pepito rattaché plus tard à la Session (titre, participants) qui diffère de la description ?
- **Recherche des Enregistrements liés** : `list_recordings` (`query` sur Titre, Tags, Participants, sans plein texte, `serveur-mcp-v1.md` § 6.3 ; `tags`, `from`, `to`), puis `get_summary` et `get_notes` ; plafond (5 au ticket 05 pour le rappel), confirmation avant d'en lire plus ?
- **Forme de la préparation** : synthèse rendue dans la conversation ; ce qui en part dans les Notes au démarrage (tout, un résumé, seulement ce que l'utilisateur retient) ; un seul bloc `append_notes` ?
- **Éléments en attente** : nom du terme (glossaire), forme de la liste dans la conversation, modification avant écriture, perte acceptée si la conversation se ferme avant la Session.
- **Passage de relais** : `prepare-meeting` charge-t-il `session-companion` lui-même au démarrage, ou l'utilisateur le fait-il ? Comment chaque skill reconnaît la liste de l'autre ?
- **Invocation** : `disable-model-invocation` (le ticket 05 a retenu `false` pour `session-companion`) ; argument (titre, date, participants).
- **Liste fermée des tools** : celle de `session-companion` en lecture avant la Session (sans écriture tant qu'il n'y a pas d'`id`) ?
- **Injection, sortie, compatibilité** : reprendre les règles des tickets 03, 04 et 05.

Skill : `grilling`. HITL : réponses de l'utilisateur seulement.

## Comments

- 2026-10-25 : ouvert bloqué côté pepito (`script-post-traitement/map.md` de pepito, Out of scope) : aucun tool de lecture du calendrier ; aucun objet ne peut recevoir une préparation avant l'Enregistrement (`append_notes`, `add_artifact` visent un `id`, qui n'apparaît qu'au démarrage de la Session).
- 2026-10-28 (ticket [05](05-session-companion.md)) : blocage levé côté plugin par la conception ci-dessus ; `needs-info` → `needs-triage` ; le ticket entre dans la Destination de la v1. Rien à proposer dans pepito pour la v1 ; un tool calendrier ou un objet de préparation restent des améliorations possibles, pas des prérequis.
