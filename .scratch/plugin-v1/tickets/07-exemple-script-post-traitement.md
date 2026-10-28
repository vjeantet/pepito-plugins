---
type: task
status: open
assignee:
blocked_by: [01, 04, 11]
triage: needs-info
---

# 07: Exemple de Script de post-traitement

Carte : [../map.md](../map.md).

## Tâche

Fournir, dans ce dépôt, un exemple de Script de post-traitement : un exécutable que l'utilisateur choisit dans pepito, qui appelle Claude Code en Exécution non interactive avec le skill `process-recording` (ticket 04) sur l'Enregistrement que pepito vient de traiter.

Ne pas inventer de variables `PEPITO_*` : leur liste, leur sens, le code de sortie et le délai sont fixés par `script-post-traitement#02`, non spécifié au 2026-10-25. L'exemple de commande de la carte de pepito (`claude -p "/pepito:process-recording $PEPITO_RECORDING_ID" --tools "" --allowedTools "mcp__pepito__*" --output-format json`) est une proposition de l'exploration, pas un contrat.

À reprendre quand les dépendances sont levées :

- emplacement : `plugins/pepito/scripts/` (copié par l'utilisateur hors du cache des plugins, que pepito ne doit jamais viser, `script-post-traitement#08`), ou racine du dépôt (`examples/`), ou page publique de pepito seulement ;
- options de Claude Code, d'après le ticket 01 : `--tools ""` (outils intégrés retirés, tools MCP gardés), `--allowedTools` avec les noms préfixés du ticket 02, `--strict-mcp-config` ou non (il retirerait le serveur déclaré par l'utilisateur), plafond de tours si l'option existe (`--max-turns` absent de `claude --help` 2.1.310) ;
- journalisation de la sortie JSON (`result`, coût) et code de sortie ;
- mises en garde en tête du script, en anglais (`CLAUDE.md` § Langues) : agent sans humain devant ses approbations, contenu non fiable (`serveur-mcp-v1.md` § 5.1 (b), § 5.5), coût, envoi du contenu au modèle de Claude Code (ticket 09) ;
- test manuel sur le Mac de l'utilisateur.

## Dépendances hors chantier

Dans pepito, chantier `script-post-traitement` (branche `claude/claudecode-skills-integration-5k3nra` au 2026-10-25) :

- `script-post-traitement#02` : contrat (variables `PEPITO_*`, répertoire courant, code de sortie, délai) ;
- `script-post-traitement#06` : confidentialité et sécurité (ce que l'exemple doit exiger ou montrer) ;
- `script-post-traitement#08` : emplacement de l'exemple publié, vérifications de l'appel à Claude Code.

Débloqué quand ces trois tickets sont clos, ou quand la spec `docs/1-product/script-post-traitement.md` de pepito est publiée.

Skill : aucun avant le déblocage ; ensuite `implement`. HITL : essai sur le Mac de l'utilisateur.

## Comments

- 2026-10-28 (ticket [04](04-process-recording.md)) : l'appel de l'exemple doit passer le marqueur d'Exécution non interactive (nom fixé au ticket 10) et l'`id` exact de l'Enregistrement (`/pepito:process-recording <marqueur> <id>`) ; sans humain, le skill ne touche que pepito (Tags du Catalogue existant, bilan dans les Notes) et n'appelle aucun Outil tiers, mais seul l'appelant l'impose : retirer les tools non pepito (`--tools ""` et `--disallowedTools` pour les autres serveurs MCP). Le skill n'appelle ni `set_summary` ni `regenerate_summary` : pas de boucle avec le Script de post-traitement de son fait. Première ligne de la sortie : `Done:`, `Nothing to do:` ou `Stopped:`.
