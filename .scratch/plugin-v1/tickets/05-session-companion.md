---
type: grilling
status: open
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
