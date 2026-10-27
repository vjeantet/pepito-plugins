# Copie de la référence du catalogue de pepito

Copie de `Packages/PepitoMCP/Tests/PepitoMCPCatalogTests/CatalogReference.json` de `vjeantet/pepito` (dépôt privé), décidée au ticket [03](../tickets/03-compatibilite-versions.md).

| Fichier | Version de pepito | Commit de pepito | Copié le |
|---|---|---|---|
| [CatalogReference-26.60.json](CatalogReference-26.60.json) | 26.60 (`main`) ; Catalogue inchangé depuis 26.56 d'après les entrées « MCP » des release notes | `894711f` | 2026-10-27 |

- Contenu : nom, `inputSchema`, `outputSchema` et `formats` des 19 tools, avec les descriptions des champs ; pas les descriptions des tools. Relu avant copie : ni chemin personnel ni secret. Ces schémas sont de toute façon visibles par tout client MCP de pepito (`tools/list`), version gratuite comprise depuis 26.59.
- La copie de pepito fait foi ; celle-ci n'est qu'un instantané daté.
- Mise à jour : à chaque release de pepito dont l'entrée « MCP » des release notes est non vide, un ticket dans ce dépôt ajoute la nouvelle copie (`CatalogReference-<version>.json`), relit les skills et ajuste la version minimale de pepito au besoin.
- Usage : contrôle mécanique, avant chaque commit qui touche un skill, que chaque Nom de base cité dans un skill existe dans la copie la plus récente (outil à écrire au ticket [10](../tickets/10-redaction-publication-v1.md)).
