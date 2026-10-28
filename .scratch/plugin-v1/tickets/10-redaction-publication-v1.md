---
type: task
status: open
assignee:
blocked_by: [02, 03, 04, 05, 08, 09, 11]
triage: needs-triage
---

# 10: Rédaction et publication de la v1

Carte : [../map.md](../map.md).

## Tâche

Consolider les décisions des tickets 02 à 05, 08 et 09, puis :

- rédiger en anglais `plugins/pepito/skills/process-recording/SKILL.md` et `plugins/pepito/skills/session-companion/SKILL.md` (frontmatter : `description`, `argument-hint`, `allowed-tools`, `disable-model-invocation` selon les tickets 04 et 05) ; noms de tools tirés de la référence du catalogue de pepito, jamais de mémoire ;
- ajouter `.mcp.json` ou non selon le ticket 02, `version` selon le ticket 08 ;
- mettre à jour les README (prérequis, version minimale de pepito, confidentialité selon le ticket 09) et le glossaire (termes nouveaux) ;
- tester : `claude plugin validate` sans erreur ; essais sur le Mac de l'utilisateur avec pepito, en interactif et en `-p` (Enregistrement de test, Session de test) ; `claude plugin eval` si le ticket 01 le juge utilisable ;
- dire si une ADR est nécessaire (déclaration du serveur MCP, règle de compatibilité) ;
- publier (fusion sur `main`, notes de version selon le ticket 08) ; `prepare-meeting` (ticket 06) et l'exemple de Script de post-traitement (ticket 07) y entrent seulement s'ils sont débloqués.

Skill : `writing-for-agents` pour les skills, `implement` pour le reste. HITL : essais et publication par l'utilisateur.

## Comments

- 2026-10-27 (ticket [03](03-compatibilite-versions.md)) : à faire ici : texte exact du message « tool absent » (tool, `pepitoVersion` lu par `get_library_info`, version minimale 26.56, mise à jour du plugin si pepito est plus récent) ; règles de lecture tolérante et de refus `isError` dans chaque skill ; contrôle mécanique, avant chaque commit qui touche un skill, que chaque Nom de base cité existe dans la copie la plus récente de [../catalog/](../catalog/README.md). README déjà mis à jour : « pepito 26.56 or later », commande HTTP de l'Assistant.
- 2026-10-28 (ticket [04](04-process-recording.md)) : à fixer ici pour `process-recording` : nom du marqueur d'Exécution non interactive (proposé : `--unattended`) ; marque fixe en anglais du bilan `append_notes`, reconnaissable à la relance ; textes exacts des phrases d'arrêt (statut refusé, `id` exact exigé) et de la ligne d'état. Le texte du skill porte la liste fermée des tools (5 lectures, `update_tags`, `add_artifact`, `append_notes`) ; le contrôle mécanique des Noms de base s'applique.
