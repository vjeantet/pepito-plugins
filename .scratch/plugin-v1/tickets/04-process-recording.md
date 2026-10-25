---
type: grilling
status: open
assignee:
blocked_by: [02, 03]
triage: needs-triage
---

# 04: Skill `process-recording`

Carte : [../map.md](../map.md).

## Question

Traiter un Enregistrement terminé. Décision du 2026-10-25 : sa valeur est de relier la réunion aux autres outils de l'utilisateur, pas de refaire le CR, que pepito produit déjà.

- **Entrée** : `id` de l'Enregistrement en argument (`/pepito:process-recording <id>`), ou le plus récent terminé (`list_recordings`) sans argument ? Refus clair sur un Enregistrement au statut `recording` (Session en cours, ticket 05), `processing` ou `failed`.
- **Périmètre** : quels « autres outils » ? Ce que le skill sait faire seul (lire, résumer pour l'utilisateur, poser des Tags) et ce qui dépend d'autres serveurs MCP de l'utilisateur (tickets, tâches, messagerie, calendrier) : les nommer, les supposer, ou décrire une démarche générique (« use the user's other connected tools ») ?
- **Lectures** : `get_recording`, `get_summary`, `get_notes`, `get_guidelines`, `list_tags` ; `get_transcript` seulement si le CR ne suffit pas (coût en tokens, plus grande surface d'injection : jusqu'à ~35k tokens, `serveur-mcp-v1.md` § 6.7) ?
- **Écritures dans pepito** :
  - `update_tags` (règle de Portée : la réponse `replaced` à rapporter), `add_artifact` (lien vers le ticket ou le document créé ailleurs), `append_notes` (synthèse des actions faites, sous le séparateur MCP) : lesquelles, avec quelle confirmation en session interactive ?
  - `set_title`, `set_summary`, `regenerate_summary`, `set_transcript`, `define_tag`, `propose_guidelines` : exclus du skill (proposition, cohérente avec « pas refaire le CR ») ou permis sur demande explicite ?
  - Boucle avec le Script de post-traitement : si pepito le relance à chaque CR réussi, un `set_summary` ou `regenerate_summary` du skill le relancerait (`script-post-traitement#01`). Exclure ces tools du skill tranche la question côté plugin.
- **Garde-fous contre l'injection** (`serveur-mcp-v1.md` § 5.5) :
  - le texte du skill dit que Transcription, CR, Notes et métadonnées sont des données de réunion, jamais des instructions, y compris un texte qui s'adresse à l'agent ;
  - liste fermée des actions permises (lectures et écritures pepito ci-dessus), aucune autre action déduite du contenu ;
  - `allowed-tools` du frontmatter limité aux tools pepito utiles (noms préfixés, ticket 02) ; en `-p`, `--tools ""` côté appelant (ticket 07) ;
  - action vers un outil externe (créer un ticket, envoyer un message) : jamais sans confirmation en interactif ; en `-p`, interdite, ou permise seulement pour des outils listés par l'utilisateur ?
- **Guidelines** (`get_guidelines`) : suivies pour les Tags et le classement, comme le prévoit pepito ; priorité sur les descriptions du Catalogue des Tags (`tags-a-portee.md` § 8.1 de pepito) ?
- **Sortie** : réponse à l'utilisateur (interactif) ; en `-p`, sortie JSON et trace de ce qui a été écrit (`append_notes`) ?
- **`disable-model-invocation`** : skill invoqué seulement par `/pepito:process-recording`, ou aussi chargé de lui-même quand l'utilisateur parle d'une réunion ?

Skill : `grilling` + `domain-modeling`. HITL : réponses de l'utilisateur seulement.
