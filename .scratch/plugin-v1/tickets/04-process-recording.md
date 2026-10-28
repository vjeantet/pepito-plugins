---
type: grilling
status: open
assignee: claude
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

## Comments

- 2026-10-27 (ticket [03](03-compatibilite-versions.md)) : règles de compatibilité communes à tous les skills : version minimale pepito 26.56 ; tool absent : arrêt avec une phrase ; lecture tolérante de `structuredContent` ; refus `isError` cité tel quel, action abandonnée, aucun réessai (garde « Étape en cours » comprise, `-p` compris). Le périmètre de ce skill ne doit citer que des tools présents dans [../catalog/](../catalog/README.md).
- 2026-10-28 (grilling, série 1, recommandations retenues) :
  1. **Périmètre** : démarche générique. Le skill lit la réunion, en tire les Suites, propose pour chacune une action dans un Outil tiers présent dans la session (aucun produit nommé), exécute après accord, consigne dans pepito (`add_artifact` pour les liens, `append_notes` pour le bilan). Sans Outil tiers : pepito seul (Suites listées, Tags). Termes « Outil tiers » et « Suite » ajoutés au glossaire (§ 2).
  2. **Entrée** : un argument en forme d'UUID est un `id` ; tout autre texte est passé à `list_recordings.query` ; sans argument, le plus récent qui remplit la condition du point 3. Hors `id` exact : titre et date affichés, confirmation avant toute écriture en interactif ; plusieurs candidats : liste et choix en interactif, arrêt en Exécution non interactive.
  3. **Enregistrements acceptés** : `completed` avec `hasSummary: true` seulement. Sinon arrêt avec une phrase qui nomme le statut (`recording` : renvoi vers `session-companion` ; `processing` : attendre la fin ; `failed` ou sans CR : générer le CR dans pepito d'abord). Pas de travail sur la Transcription seule.
  4. **Tools pepito exclus** : `set_title`, `set_summary`, `regenerate_summary`, `set_transcript`, `define_tag`, `propose_guidelines`, `update_artifact`, `remove_artifact`, même sur demande explicite ; le texte du skill porte la liste fermée des tools permis. Règle aussi, côté plugin, la boucle avec le Script de post-traitement (`script-post-traitement#01`).
  5. **`disable-model-invocation: true`** : invocation par `/pepito:process-recording` seulement ; à rouvrir après le ticket 11.
  6. **Exécution non interactive** : visée, par un marqueur explicite en argument passé par l'appelant (nom à fixer, ex. `--unattended`) ; sans marqueur, comportement interactif (demander et attendre, sûr en `-p` : rien n'est écrit).
- 2026-10-28 (grilling, série 2, recommandations retenues) :
  7. **Lectures** : toujours `get_recording`, `get_summary`, `get_notes`, `list_tags`, `get_guidelines`. `get_transcript` en interactif seulement, pour une Suite précise que le CR ne suffit pas à établir, en disant pourquoi ; jamais en Exécution non interactive.
  8. **Écritures pepito, interactif** : un plan unique (Suites, actions dans les Outils tiers, Tags, texte du bilan) approuvé, amendé ou réduit d'un bloc, puis exécuté sans autre question. `update_tags` en ajout seul, Catalogue des Tags de préférence, Tag nouveau seulement s'il est dans le plan, `replaced` rapporté. Un `add_artifact` par objet créé dans un Outil tiers qui rend une URL, titre lisible. Un bilan `append_notes` unique, seulement si quelque chose a été fait ou décidé.
  9. **Exécution non interactive** : pepito seul. Tags du Catalogue des Tags existant seulement, Tag à portée seulement si l'Enregistrement n'a aucun Tag dans cette Portée ; `append_notes` avec les Suites proposées, non faites. Aucun appel à un Outil tiers, lecture comprise. Le texte du skill le dit ; l'interdiction effective revient à l'appelant (`--disallowedTools` / `--tools`, ticket 07). Actions tierces sans humain à rouvrir avec le contrat `PEPITO_*`.
  10. **Guidelines** : priment sur les descriptions du Catalogue des Tags pour les Tags ; orientent le choix et la destination d'un Outil tiers en interactif, toujours dans le plan approuvé ; n'élargissent jamais la liste fermée des actions, n'ouvrent pas les Outils tiers en Exécution non interactive.
  11. **Texte qui s'adresse à l'agent** : ignoré comme consigne, signalé en une ligne dans la réponse, jamais recopié dans les Notes ; le reste du travail continue. Une demande dite en réunion reste une Suite, proposée dans le plan, jamais exécutée parce que le texte le dit.
  12. **Relance** : le skill repère son bilan précédent dans les Notes, le montre, ne propose que les Suites non faites ; refait une Suite seulement à la demande. En Exécution non interactive, rien n'est écrit si un bilan précédent existe. Marque reconnaissable du bilan à fixer au ticket 10.
  13. **Sortie** : texte anglais, pas de JSON propre au skill tant que `PEPITO_*` n'existe pas ; première ligne `Done:`, `Nothing to do:` ou `Stopped:` (règle « phrase en première ligne » des tickets 02 et 03).
