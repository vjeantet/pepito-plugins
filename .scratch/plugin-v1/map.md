# Plugin pepito v1

## Destination

Une première version publiée du Plugin pepito dans la marketplace `pepito-plugins` de ce dépôt : skills `process-recording` et `session-companion` rédigés en anglais, testés sur le Mac de l'utilisateur avec pepito, README d'installation à jour, règle de version et notes de version fixées. `prepare-meeting` et l'exemple de Script de post-traitement y entrent si pepito a levé leurs blocages ; sinon ils restent ouverts pour une version suivante.

## Notes

- Origine : exploration du 2026-10-25 avec l'utilisateur, dans le dépôt pepito (« renforcer l'intégration aux Outils IA comme Claude Code »), recentrée sur deux briques : le Script de post-traitement dans pepito, ce plugin ici. Carte jumelle dans pepito : `.scratch/script-post-traitement/map.md`, qui range le plugin dans son « Out of scope » et ne fixe que ce dont il dépend. Au 2026-10-25, ce chantier n'existe que sur la branche `claude/claudecode-skills-integration-5k3nra` de pepito.
- Domaine : `docs/glossaire.md`. Contrat : specs `serveur-mcp-*.md` de pepito (dépôt privé) et référence du catalogue (`CatalogReference.json`), qui fait foi.
- Catalogue au 2026-10-25 (19 tools, référence du catalogue) :
  - lecture (`readOnlyHint`) : `list_recordings`, `get_recording`, `get_transcript`, `get_summary`, `get_notes`, `list_tags`, `get_library_info`, `get_guidelines` ;
  - écriture sur un Enregistrement : `append_notes`, `set_title`, `set_transcript`, `set_summary`, `regenerate_summary`, `update_tags`, `add_artifact`, `update_artifact`, `remove_artifact` ;
  - autres écritures : `define_tag` (Catalogue des Tags), `propose_guidelines` (validée par l'utilisateur dans pepito).
- Règles du contrat qui pèsent sur les skills :
  - Session en cours : `append_notes`, `get_notes`, `update_tags`, tools d'Artefacts et `define_tag` autorisés ; `set_title`, `regenerate_summary`, `set_transcript`, `set_summary`, `get_transcript`, `get_summary` refusés ; aucune Transcription pendant la Session ; une Session annulée part en Corbeille avec ce que l'Outil IA y a écrit (`serveur-mcp-session-en-cours.md` § 2, § 5, § 8.3).
  - Garde « Étape en cours » : `regenerate_summary`, `set_title`, `set_transcript`, `set_summary` refusés tant qu'une Étape de l'Enregistrement est `in_progress` (`serveur-mcp-v1.md` § 6.6).
  - Sans Événement, une génération du CR réécrit le Titre posé par `set_title` (`serveur-mcp-v1.md` § 6.5).
  - Contenu non fiable : les descriptions des lectures disent que le texte est une donnée de réunion ; aucun filtrage ; `instructions` interdit de modifier, déplacer ou supprimer un fichier du Dossier, consigne et non protection (`serveur-mcp-v1.md` § 5.5).
  - Contenus en texte intégral, sans pagination ; plus longue Transcription relevée 151 292 octets ; `get_transcript` porte `_meta["anthropic/maxResultSizeChars"] = 500000` (`serveur-mcp-v1.md` § 6.7).
  - Versionnement : noms, `inputSchema`, `outputSchema` et séparateur d'`append_notes` forment le contrat ; changements libres, renommage et retrait compris, sans alias ni dépréciation, annoncés dans les release notes ; pas de version de contrat, `get_library_info` et `serverInfo` portent la version de pepito ; « les skills et prompts utilisateur cassent sans signal », et en `-p` une règle `mcp__pepito__<ancien>` devient inerte et l'appel est refusé sans message (`serveur-mcp-v1.md` § 9 ; constaté le 2026-10-25 : le refus est listé dans `permission_denials` de la sortie JSON, ticket 01).
- Faits Claude Code : [research/faits-claude-code.md](research/faits-claude-code.md) (documentation lue en brut et essais sur Claude Code 2.1.310 le 2026-10-25, ticket 01 ; essais avec le vrai pepito : ticket 11). Banc d'essai réutilisable : [research/banc-essai/](research/banc-essai/).
- **Écart avec les faits notés dans pepito le 2026-10-25** : « si le même serveur MCP est déclaré par l'utilisateur et par un plugin, la déclaration utilisateur l'emporte ». Constaté (ticket 01) : un serveur de plugin n'est écarté comme doublon que si sa commande et ses `args` sont ceux d'un serveur activé au-dessus de lui ; le nom ne suffit pas, et sinon chaque tool existe en double sous deux préfixes. Pèse sur le ticket 02 et sur l'exemple de commande `claude -p … --allowedTools "mcp__pepito__*"` de `script-post-traitement#08`.
- **Écart avec la prémisse « le catalogue ne fait que s'étendre »** : c'est l'histoire observée, pas le contrat. `serveur-mcp-v1.md` § 9 permet renommage et retrait sans alias. Le ticket 03 part de la règle écrite.
- Constat d'initialisation : `claude plugin validate` passe avec deux avertissements (`version` absente, icône absente).
- Skills de travail : `research` (ticket 01), `grilling` + `domain-modeling` (décisions), `to-spec` si une spec du plugin est jugée utile, `writing-for-agents` pour la rédaction des skills (ticket 10).

## Tickets et frontière

| N° | Titre | Type | blocked_by | triage |
|---|---|---|---|---|
| 01 | [Faits Claude Code à vérifier](tickets/01-faits-claude-code.md) | research | - | needs-triage (fermé) |
| 02 | [Déclarer ou non le serveur MCP dans le plugin](tickets/02-declaration-serveur-mcp.md) | grilling | 01 | needs-triage |
| 03 | [Compatibilité entre versions de pepito et du plugin](tickets/03-compatibilite-versions.md) | grilling | 01, 02 | needs-triage |
| 04 | [Skill `process-recording`](tickets/04-process-recording.md) | grilling | 02, 03 | needs-triage |
| 05 | [Skill `session-companion`](tickets/05-session-companion.md) | grilling | 02, 03 | needs-triage |
| 06 | [Skill `prepare-meeting`](tickets/06-prepare-meeting.md) | grilling | - | needs-info |
| 07 | [Exemple de Script de post-traitement](tickets/07-exemple-script-post-traitement.md) | task | 01, 04, 11 | needs-info |
| 08 | [Distribution et versionnement](tickets/08-distribution-versionnement.md) | grilling | 01 | needs-triage |
| 09 | [Confidentialité](tickets/09-confidentialite.md) | grilling | - | needs-triage |
| 10 | [Rédaction et publication de la v1](tickets/10-redaction-publication-v1.md) | task | 02, 03, 04, 05, 08, 09, 11 | needs-triage |
| 11 | [Essais sur le Mac avec pepito](tickets/11-essais-mac-pepito.md) | research | - | ready-for-human |

Frontière : 02, 08, 09 ; 11 attend l'utilisateur sur son Mac (`ready-for-human`). 06 n'a pas de bloquant dans le chantier mais attend pepito (`needs-info`).

## Decisions so far

- 2026-10-25 (avec l'utilisateur, dans pepito) : intégration en deux briques séparées ; le plugin ne dépend que du contrat MCP et du contrat `PEPITO_*` du Script de post-traitement ; pepito n'écrit dans aucune configuration d'Outil IA ni ne lance de CLI tiers (`serveur-mcp-v1.md` § 8.2 [T07]) ; terme « Script de post-traitement », jamais « Script ».
- 2026-10-25 (avec l'utilisateur, dans pepito) : trois skills envisagés, `process-recording` (relier la réunion aux autres outils, pas refaire le CR), `session-companion` (sans Transcription en direct), `prepare-meeting` (bloqué côté pepito).
- 2026-10-25 (avec l'utilisateur) : tout ce qui est destiné aux utilisateurs (README, manifestes, messages des skills, exemples, notes de version) est en anglais, le dépôt étant public ; la documentation de travail et les specs restent en français (`CLAUDE.md` § Langues).
- 2026-10-25 : [Faits Claude Code à vérifier](tickets/01-faits-claude-code.md) : skill de plugin développé en `-p` avec ses arguments ; `allowed-tools` (nom exact ou `mcp__pepito__*`) suffit en `-p`, plugin installé compris ; `--tools ""` garde les tools MCP ; serveur de plugin écarté comme doublon seulement à commande et `args` identiques, sinon tools en double ; sans `version`, tout commit du dépôt est une mise à jour ; `--bare` deviendra le défaut de `-p`. Essais avec le vrai pepito reportés au ticket 11.
- 2026-10-25 (initialisation du dépôt, réversible) : marketplace `pepito-plugins`, plugin `pepito` à `./plugins/pepito`, sans `version` ni `.mcp.json` en attendant les tickets 02 et 08.

## Not yet specified

1. **Essais avec le vrai pepito** (ticket 11) : noms réels, doublon avec la commande de l'Assistant de connexion, Relais MCP joint par un enfant de pepito, reconnexion.
2. **Serveur MCP** (ticket 02) : le plugin le déclare-t-il, sous quel nom et avec quelle commande ; comment un skill nomme les tools (Nom de base, nom préfixé) ; que fait un skill quand pepito n'est pas connecté.
3. **Compatibilité** (ticket 03) : version minimale de pepito, comportement d'un skill face à un tool absent, renommé ou refusé, et face à un champ nouveau.
4. **`process-recording`** (ticket 04) : périmètre (quels « autres outils »), tools appelés, écritures permises, garde-fous contre l'injection, interaction avec le Script de post-traitement (boucle `set_summary` / `regenerate_summary`).
5. **`session-companion`** (ticket 05) : usages pendant la Session, repérage de la Session en cours, contexte des Enregistrements passés, Session annulée.
6. **`prepare-meeting`** (ticket 06) : attend un tool calendrier et un objet pour la préparation dans pepito.
7. **Exemple de Script de post-traitement** (ticket 07) : attend le contrat `PEPITO_*` (`script-post-traitement#02`), les règles de sécurité (`#06`) et la décision sur l'exemple publié (`#08`).
8. **Distribution** (ticket 08) : nom de la marketplace, champ `version`, notes de version, mise à jour automatique, version française des README, icône.
9. **Confidentialité** (ticket 09) : formulations du README et des skills, alignées sur celles de pepito.

## Out of scope

- Tout code de l'app pepito et toute écriture dans le dépôt pepito : les besoins du plugin envers pepito (tool calendrier, objet de préparation, contrat `PEPITO_*`) se notent dans les tickets, l'utilisateur les porte dans pepito.
- Autres Outils IA (Codex, opencode, Witsy, Claude Desktop) : le plugin vise Claude Code seul ; un exemple de Script de post-traitement pour un autre Outil IA relève de `script-post-traitement#08`.
- Prompts MCP (`prompts/list`) : exclus par `serveur-mcp-v1.md` § 6.1 [T04].
- Pilotage de la Session (Start, Stop) : hors du contrat MCP (`serveur-mcp-v1.md` § 10).
- Un `CLAUDE.md` ou `AGENTS.md` dans le Dossier de pepito : non retenu par l'exploration du 2026-10-25 (`script-post-traitement/map.md`, Out of scope).
- Soumission au catalogue public de plugins d'Anthropic : à rouvrir après la v1.
