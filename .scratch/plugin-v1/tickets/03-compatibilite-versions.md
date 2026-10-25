---
type: grilling
status: open
assignee:
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
