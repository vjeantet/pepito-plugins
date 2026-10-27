---
type: grilling
status: closed
assignee: claude
blocked_by: [01, 02]
triage: needs-triage
---

# 03: Compatibilité entre versions de pepito et du plugin

Carte : [../map.md](../map.md).

## Question

Le plugin et pepito sont publiés séparément ; l'utilisateur met l'un à jour sans l'autre (mise à jour automatique du plugin désactivée par défaut, pepito par Sparkle).

**Prémisse à corriger** : « le catalogue ne fait que s'étendre » décrit l'histoire observée (16 tools en v1, 19 au 2026-10-25), pas le contrat. `serveur-mcp-v1.md` § 9 permet renommage et retrait sans alias ni période de dépréciation, annoncés dans les release notes de pepito ; le même § note qu'un skill utilisateur casse alors sans signal et qu'en `-p` une règle `mcp__pepito__<ancien>` devient inerte et l'appel est refusé sans message. Ce ticket part de la règle écrite, sauf si l'utilisateur décide de demander à pepito un engagement plus fort (ajout seul), à porter dans pepito.

- **Version minimale de pepito** : déclarée où (README, description du skill) ; lue comment (`get_library_info` porte la version de pepito, pas de version de contrat) ; un skill la vérifie-t-il avant d'agir, ou se fie-t-il aux tools présents ?
- **Tool absent** (pepito plus ancien, ou tool retiré) : le skill s'arrête avec un message qui nomme le tool et la version minimale, ou continue en dégradé (ex. `define_tag` absent : poser les Tags sans description) ? Règle unique pour tous les skills.
- **Tool renommé** : rien ne le signale ; les tests du ticket 10 suffisent-ils, ou faut-il suivre les entrées « MCP » des release notes de pepito à chaque release du plugin ?
- **Champ nouveau ou absent** dans un `structuredContent` (ex. `startedBy` absent des anciens Enregistrements, `summaryProducedAt` à `null`) : lecture tolérante, jamais d'échec sur un champ manquant.
- **Refus `isError`** (garde « Étape en cours », Session en cours, `id` « supprimé ou fusionné ») : le skill rapporte le message de pepito tel quel, réessaie plus tard, ou abandonne ? En `-p`, sans humain ?
- **Référence du catalogue** : la recopier dans ce dépôt (public) pour tester les skills contre elle ? Elle couvre noms et schémas, pas les descriptions ; vérifier qu'elle ne porte rien de privé avant toute copie.

Skill : `grilling`. HITL : réponses de l'utilisateur seulement.

## Comments

- 2026-10-27 (ticket [02](02-declaration-serveur-mcp.md)) : les skills portent `allowed-tools: mcp__pepito__*`. Un tool renommé ou ajouté reste permis : le cas « règle `mcp__pepito__<ancien>` inerte, appel refusé en `-p` » ne touche plus les skills, seulement un appelant qui passe une liste exacte en `--allowedTools`. Un renommage reste un tool introuvable pour le texte du skill, qui le nomme par son Nom de base. Le message « pepito absent » est fixé au ticket 02 ; ce ticket décide du message « tool absent ».
- 2026-10-27 (relecture de pepito `main`, 26.60, commit `894711f`) : le Relais MCP stdio est retiré depuis 26.58 ; pepito sert le MCP par le Point d'accès HTTP (`http://127.0.0.1:47374/mcp`, `Authorization: Bearer <jeton>`), tools et paramètres inchangés (`serveur-mcp-v1.md` § 3.6, § 11 sexies). Le MCP est sans licence depuis 26.59 (§ 11 septies). Les messages `isError` sont hors contrat (§ 9). Historique du Catalogue d'après les entrées « MCP » des release notes : 26.36 (14 tools), 26.37 (Guidelines), 26.39 (écritures pendant la Session en cours), 26.53 (`startedBy`, `summaryProducedAt`, `get_summary.version`), 26.55 (`list_tags` cassant, `update_tags.replaced`), 26.56 (`define_tag`) ; rien depuis.

## Resolution

2026-10-27, avec l'utilisateur (une série de questions, recommandations toutes retenues).

1. **Faits de transport corrigés** dans `CLAUDE.md`, le glossaire, les Notes de la carte, le ticket [02](02-declaration-serveur-mcp.md) (commentaire) et le ticket [11](11-essais-mac-pepito.md) (questions réécrites) : Point d'accès HTTP à la place du Relais MCP.
2. **Pas d'engagement « ajout seul » demandé à pepito** : le plugin part de la règle écrite (`serveur-mcp-v1.md` § 9 : renommage et retrait libres, annoncés dans l'entrée « MCP » des release notes). Rien à porter dans pepito.
3. **Version minimale de pepito : 26.56**, plus ancienne version dont le Catalogue est l'actuel. Écrite dans le README (« Requires pepito 26.56 or later ») et dans le corps de chaque skill, pour le message de tool absent. Le transport n'entre pas dans le calcul : le plugin ne voit que des tools, et l'Assistant de connexion de chaque version donne la bonne commande. Relevée quand un skill se met à utiliser un tool ou un champ plus récent.
4. **Pas de vérification de version avant d'agir** : le skill se fie aux tools présents. `get_library_info.pepitoVersion` ne sert qu'à rédiger le message de tool absent.
5. **Tool absent : arrêt**, règle unique pour tous les skills, sans mode dégradé ; avant toute écriture si possible ; une phrase en anglais en première ligne de la réponse, `-p` compris, qui nomme le tool, la version de pepito lue, la version minimale, et propose de mettre à jour le plugin si pepito est plus récent. Exemple : « pepito <pepitoVersion> does not provide `<tool>`. This plugin needs pepito 26.56 or later; if your pepito is newer, update the plugin. » Texte exact au ticket [10](10-redaction-publication-v1.md). Raison : avec 26.56 pour minimum, les 19 tools existent dans toute version prise en charge ; un tool absent signale un pepito trop ancien ou un renommage, et continuer donnerait un résultat partiel sans signal.
6. **Lecture tolérante** de `structuredContent`, écrite dans chaque skill : champ inconnu ignoré, champ absent ou `null` traité comme non renseigné, jamais d'échec pour cette seule raison (cas existants : `startedBy` `null` avant 26.53, `summaryProducedAt` `null` sans CR, `durationSeconds` `null` pour une Transcription importée).
7. **Refus `isError`** (garde « Étape en cours », Session en cours, `id` « supprimé ou fusionné », clé API absente…) : le skill cite le message de pepito tel quel avec le nom du tool, et abandonne l'action concernée ; aucun réessai automatique, ni en interactif ni en `-p` ; jamais d'interprétation du texte, hors contrat (§ 9). `id` « supprimé ou fusionné » : en interactif, le skill propose `list_recordings` pour retrouver l'Enregistrement ; en `-p`, il s'arrête.
8. **Veille et copie de la référence** :
   - à chaque release de pepito dont l'entrée « MCP » des release notes est non vide, un ticket dans ce dépôt : nouvelle copie de la référence, relecture des skills, version minimale ;
   - copie de la référence du catalogue dans ce dépôt : [../catalog/](../catalog/README.md) (`CatalogReference-26.60.json`, relue : rien de privé, schémas déjà visibles par `tools/list`) ;
   - contrôle mécanique avant chaque commit qui touche un skill : chaque Nom de base cité existe dans la copie la plus récente ; outil écrit au ticket [10](10-redaction-publication-v1.md).

Pas d'ADR : chaque point se change sans coût (texte des skills, README, copie).
