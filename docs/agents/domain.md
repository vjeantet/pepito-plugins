# Documentation de domaine

Comment les skills de travail (`.claude/skills/`) consomment la documentation de domaine de ce repo (single-context).

## Avant d'explorer, lire

- **`docs/glossaire.md`** : vocabulaire de référence, tient lieu de `CONTEXT.md`. Il n'y a pas de `CONTEXT.md` à la racine et il ne faut pas en créer ; `/domain-modeling` enrichit le glossaire en respectant son format (tables Terme / Code / Définition / Ne pas confondre avec). Pour un terme repris de pepito, le glossaire de pepito (`docs/1-product/glossaire.md`, dépôt privé) et la référence du catalogue MCP font foi : en cas de divergence, mettre à jour ce glossaire.
- **`docs/adr/`** : ADR touchant la zone de travail. Créé à la demande par `/domain-modeling`. Les décisions antérieures sont dans `CLAUDE.md` (§ Décisions).
- **Contrat de pepito** : specs du serveur MCP citées dans `CLAUDE.md` (§ Sources dans pepito), lues dans un clone en lecture seule de `vjeantet/pepito` ; manifestes et skills du plugin sous `plugins/pepito/`.

Si l'un de ces éléments est absent, continuer sans le signaler.

## Utiliser le vocabulaire du glossaire

Quand une production nomme un concept du domaine (titre de ticket, nom de skill, description, hypothèse), employer le terme du glossaire, jamais un synonyme qu'il écarte (ex. « session » pour une Connexion MCP, « Script » pour le Script de post-traitement). Un concept absent du glossaire signale soit un vocabulaire inventé (à reconsidérer), soit un manque réel (à noter pour `/domain-modeling`).

Dans le contenu destiné au LLM (anglais), employer les termes anglais de pepito : *recording*, *transcript*, *summary*, *notes*, *tags*, *artifact*, *guidelines*, *post-processing script*.

## Signaler les conflits de décision

Si une production contredit un ADR, une décision de `CLAUDE.md` ou une décision de pepito (spec ou `CLAUDE.md` de pepito), le dire explicitement plutôt que passer outre :

> _Contredit `serveur-mcp-v1.md` § 8.2 [T07] (…), mais mérite d'être rouvert parce que…_
