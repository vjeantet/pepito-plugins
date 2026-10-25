---
type: grilling
status: open
assignee:
blocked_by: [01]
triage: needs-triage
---

# 08: Distribution et versionnement

Carte : [../map.md](../map.md).

## Question

- **Nom de la marketplace** : `pepito-plugins` posé à l'initialisation (installation `pepito@pepito-plugins`) ; le garder, ou `pepito` (`pepito@pepito`) ? Le changer après publication casse les installations et les commandes documentées : à trancher avant la v1.
- **Champ `version`** (faits du 2026-10-25, [../research/faits-claude-code.md](../research/faits-claude-code.md) § 2) :
  - absent (état actuel) : la version est le SHA du commit, chaque commit poussé est une mise à jour ; `claude plugin validate` avertit ;
  - présent dans `plugin.json` seul (jamais aussi dans l'entrée de marketplace) : seule une hausse de `version` publie ; un commit de documentation n'atteint personne ;
  - schéma : semver propre au plugin, ou aligné sur les versions de pepito (`26.NN`) pour dire la compatibilité (lien avec le ticket 03) ?
- **Branche publiée** : `main` sert la marketplace ; travail sur des branches, publication par fusion ? Tags git par version ?
- **Notes de version** : fichier `CHANGELOG.md`, releases GitHub, ou rien ; entrée obligatoire quand un skill change de comportement ou de version minimale de pepito ?
- **Mise à jour automatique** : désactivée par défaut pour une marketplace tierce ; le README explique comment l'activer (fait). Le recommander, ou recommander la mise à jour manuelle pour garder la main sur ce qui tourne en `-p` (ticket 07) ?
- ~~**Langue des README**~~ : tranché le 2026-10-25 par l'utilisateur, tout ce qui est destiné aux utilisateurs est en anglais (`CLAUDE.md` § Langues). Reste ouvert : une version française des README (pepito est localisé EN et FR), ou anglais seul ?
- **Icône** : `claude plugin validate` relève `ICON_MISSING` (catalogue public de plugins) ; reprendre l'icône de pepito (droits, taille 512 à 2048 px) ou s'en passer tant que le plugin n'est pas soumis ?

Skill : `grilling`. HITL : réponses de l'utilisateur seulement.
