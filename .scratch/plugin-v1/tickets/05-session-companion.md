---
type: grilling
status: closed
assignee: claude
blocked_by: [02, 03]
triage: needs-triage
---

# 05: Skill `session-companion`

Carte : [../map.md](../map.md).

## Question

Accompagner une Session en cours. Décision du 2026-10-25 : pas de Transcription en direct ; le skill ne sert que par `append_notes`, `add_artifact`, `update_tags` et le contexte des Enregistrements passés.

- **Usages** : lesquels retenir pour la v1 ?
  - prise de notes dictée à l'agent (`append_notes`, sous le séparateur MCP, distinct des Notes humaines) ;
  - rattacher un document ou une URL ouverts pendant la réunion (`add_artifact`) ;
  - poser des Tags dès la Session (`update_tags`, `list_tags`, Guidelines) ;
  - rappeler ce qui s'est dit aux réunions passées sur le même sujet (`list_recordings` par `query`, Tags ou dates, puis `get_summary`, `get_notes` de ces Enregistrements) ;
  - autre ?
- **Repérage de la Session** : premier résultat de `list_recordings` au statut `recording` (`serveur-mcp-session-en-cours.md` § 7) ; aucune Session : le skill le dit et s'arrête, ou propose les usages sur l'Enregistrement le plus récent ?
- **Tools refusés pendant la Session** (`set_title`, `get_transcript`, `get_summary`, `regenerate_summary`, `set_summary`, `set_transcript`) : le skill ne les appelle pas ; il le dit si l'utilisateur les demande, et renvoie vers `process-recording` après le Stop.
- **Session annulée** : un Stop pendant le Démarrage ou sous le Seuil minimum met l'Enregistrement en Corbeille avec les Notes, Artefacts et Tags ajoutés, alors que les appels ont réussi (`serveur-mcp-session-en-cours.md` § 5). Le skill le signale-t-il, par exemple en gardant dans sa réponse ce qu'il a écrit ?
- **Stop pendant l'usage** : une écriture après le Stop vise l'Enregistrement terminé ; le skill le remarque-t-il (statut relu) ?
- **Mode d'usage** : une invocation par action (`/pepito:session-companion note …`), ou une conversation qui dure le temps de la réunion ?
- **Injection** : surface limitée aux Notes et aux métadonnées pendant la Session (`serveur-mcp-session-en-cours.md` § 8.3), mais les CR et Notes des Enregistrements passés sont lus : mêmes garde-fous que le ticket 04.

Skill : `grilling`. HITL : réponses de l'utilisateur seulement.

## Comments

- 2026-10-27 (ticket [03](03-compatibilite-versions.md)) : règles de compatibilité communes à tous les skills : version minimale pepito 26.56 ; tool absent : arrêt avec une phrase ; lecture tolérante de `structuredContent` ; refus `isError` cité tel quel, action abandonnée, aucun réessai (refus « Session en cours » compris).
- 2026-10-28 (ticket [04](04-process-recording.md)) : choix de `process-recording` à reprendre ou à écarter ici, pour des skills cohérents : `disable-model-invocation: true` ; liste fermée des tools écrite dans le texte du skill ; texte qui s'adresse à l'agent ignoré et signalé en une ligne ; première ligne `Done:` / `Nothing to do:` / `Stopped:` ; contenu dans la langue de la réunion, messages fixes en anglais. Termes **Outil tiers** et **Suite** au glossaire. `process-recording` refuse le statut `recording` et renvoie vers ce skill.
- 2026-10-28 (grilling, série 1) :
  1. **Usages** : les quatre retenus (notes dictées, Artefacts, Tags, rappel des réunions passées). Liste fermée : `list_recordings`, `get_recording`, `get_notes`, `list_tags`, `get_guidelines`, `get_summary` (Enregistrements passés seulement), `append_notes`, `add_artifact`, `update_tags` (ajout seul). Exclus même sur demande : `define_tag`, `update_artifact`, `remove_artifact`, `propose_guidelines`, `get_transcript`, `set_title`, `set_summary`, `regenerate_summary`, `set_transcript`.
  2. **Mode d'usage** : une invocation ouvre un accompagnement qui dure le reste de la conversation ; un argument vaut première demande.
  3. **Aucune Session en cours** (réponse de l'utilisateur, autre que la recommandation) : l'utilisateur veut sans doute préparer une réunion à venir ; après sa confirmation, les quatre usages doivent être possibles en attendant le démarrage de l'Enregistrement ; l'utilisateur en fait un skill à part entière (série 2, point 8).
  4. **Invocation** (réponse de l'utilisateur, autre que la recommandation) : `disable-model-invocation: false` ; Claude peut charger le skill de lui-même. Diffère de `process-recording` ; la `description` devient le déclencheur (ticket 10).
  5. **Exécution non interactive** : aucun mode propre, ni marqueur ni détection de `-p` ; le README dit que le skill vise une session interactive. Le Script de post-traitement est lancé après le Traitement, jamais pendant une Session.
  6. **Tools refusés pendant la Session** : jamais appelés sur la Session ; le skill dit que l'action n'est pas possible pendant la Session et renvoie vers `/pepito:process-recording` après le Stop ; une suggestion de Titre est notée dans les Notes (sans Événement, le CR réécrit le Titre, `serveur-mcp-v1.md` § 6.5).
  7. **Injection** : garde-fous du ticket 04 ; les Notes humaines de la Session sont des données comme le reste ; seule la conversation avec l'utilisateur porte des consignes.
- 2026-10-28 (grilling, série 2, recommandations retenues) :
  8. **Préparation** : portée par `prepare-meeting` (ticket [06](06-prepare-meeting.md), rouvert) : lecture du passé tout de suite, notes, Artefacts et Tags gardés en attente dans la conversation. Sans Session, `session-companion` propose cette préparation après confirmation ; au démarrage de la Session, il reprend les éléments en attente listés dans la conversation. Le tool calendrier de pepito n'est plus requis : l'utilisateur décrit la réunion, ou un Outil tiers de calendrier la donne. Le ticket 06 entre dans la Destination de la v1.
  9. **Démarrage de la Session** : `list_recordings` relu à chaque message de l'utilisateur, ou à son signal (« c'est parti ») ; rattachement après confirmation (Titre, début, Événement), la Session pouvant être une autre réunion (Auto-record) ; éléments en attente écrits d'un bloc (un `append_notes`, puis les `add_artifact`, un `update_tags`).
  10. **Notes pendant la Session** : une note par demande, écrite aussitôt (une Session annulée ou une conversation fermée ne perd que le non-dit ; une note écrite après le Stop peut manquer au CR, `serveur-mcp-session-en-cours.md` § 3.5) ; texte dicté, nettoyé de la forme seulement, sans reformulation ni ajout.
  11. **Stop pendant l'usage** : la Session est relue avant chaque écriture ; terminée, l'agent le dit, écrit après confirmation sur l'Enregistrement terminé en prévenant que la note peut manquer au CR, puis arrête l'accompagnement avec un renvoi vers `/pepito:process-recording`.
  12. **Session annulée** : constatée par le contrat (l'Enregistrement a disparu de `list_recordings`), jamais par le texte d'une erreur (ticket 03) ; l'agent dit que la Session a été retirée, probablement annulée, et rend le texte de ce qu'il y avait écrit. Aucune mise en garde préventive.
  13. **Initiative** : à l'ouverture, une ligne (Session trouvée : Titre, début, Tags) et une offre de rappel si des Enregistrements passés correspondent ; Tags proposés à la demande seulement ; ensuite aucune initiative. Rappel : au plus 5 Enregistrements lus, cités par Titre et date, demande avant d'en lire plus.
  14. **Forme des réponses** : `Stopped:` en première ligne seulement à l'arrêt (pas de Session, pepito absent, tool absent, fin après le Stop) ; sinon réponses courtes sans préfixe. Contenu dans la langue de l'utilisateur, messages fixes en anglais.
- 2026-10-28 (grilling, série 3, recommandations retenues) :
  15. **Artefacts** : cible (chemin ou URL) donnée par l'utilisateur ; titre donné par lui, sinon nom du fichier ou hôte et chemin de l'URL ; aucune lecture de la page pour son titre.
  16. **Guidelines** : `get_guidelines` lu à l'ouverture ; orientent les Tags proposés et la forme des notes ; n'élargissent jamais la liste fermée.
  17. **Nouvelle Session dans la même conversation** : rattachement après confirmation comme au point 9, jamais d'écriture d'office.

## Resolution

2026-10-28, avec l'utilisateur (grilling en trois séries ; détail dans les Comments, points 1 à 17 ; points 3 et 4 tranchés autrement que la recommandation).

**Rôle.** `session-companion` accompagne la Session en cours, sans Transcription en direct. Invocable par l'utilisateur (`/pepito:session-companion`) ou par le modèle (`disable-model-invocation: false`). Une invocation ouvre un accompagnement qui dure le reste de la conversation ; un argument vaut première demande.

**Usages et tools.** Notes dictées, Artefacts, Tags en ajout seul, rappel des réunions passées. Liste fermée, écrite dans le texte du skill : `list_recordings`, `get_recording`, `get_notes`, `list_tags`, `get_guidelines`, `get_summary` (Enregistrements passés seulement), `append_notes`, `add_artifact`, `update_tags`. Tout le reste exclu, même sur demande. Tools refusés pendant la Session jamais appelés : le skill le dit et renvoie vers `process-recording` ; suggestion de Titre notée.

**Sans Session.** Préparation proposée après confirmation, portée par `prepare-meeting` (ticket 06, rouvert et entré dans la v1) ; éléments en attente listés dans la conversation et repris au démarrage.

**Démarrage.** `list_recordings` relu à chaque message ou au signal de l'utilisateur ; rattachement après confirmation, y compris pour une nouvelle Session dans la même conversation ; éléments en attente écrits d'un bloc.

**Pendant la Session.** Ouverture : une ligne sur la Session et une offre de rappel ; ensuite aucune initiative. Rappel : 5 Enregistrements au plus, cités par Titre et date. Une note par demande, écrite aussitôt, texte dicté. Artefacts : cible et titre de l'utilisateur, sinon nom du fichier ou de l'URL. Guidelines lues à l'ouverture, sans élargir la liste fermée.

**Stop et annulation.** Session relue avant chaque écriture. Terminée : écriture après confirmation avec avertissement sur le CR, puis fin de l'accompagnement et renvoi vers `process-recording`. Disparue de `list_recordings` : signalée comme retirée, texte écrit rendu à l'utilisateur.

**Injection, sortie, compatibilité.** Garde-fous du ticket 04, Notes humaines de la Session comprises. `Stopped:` seulement à l'arrêt, réponses courtes sinon ; messages fixes en anglais, contenu dans la langue de l'utilisateur. Socle du ticket 03 (version minimale, tool absent, lecture tolérante, refus cité tel quel). Aucun mode d'Exécution non interactive.

Pas d'ADR : tout se change dans le texte du skill. Rien à porter dans pepito : le blocage « calendrier et objet de préparation » de `prepare-meeting` tombe côté plugin. Glossaire inchangé ; le terme des éléments préparés en attente se fixera au ticket 06.
