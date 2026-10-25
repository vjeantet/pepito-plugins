# pepito-plugins

Marketplace Claude Code du plugin **pepito**. [pepito](https://pepito.sodadi.fr) est une app macOS qui enregistre les réunions, les transcrit et produit leurs comptes-rendus sur votre Mac. Le plugin `pepito` apporte à Claude Code des skills qui relient ces réunions à vos autres outils, en passant par le serveur MCP local de pepito. Il ne contient aucun code de l'app.

**État : squelette.** Aucun skill n'est encore publié ; le travail en cours est suivi dans [.scratch/SITUATION.md](.scratch/SITUATION.md).

## Installation rapide

Prérequis : pepito lancé, serveur MCP activé dans Settings > MCP, Claude Code connecté à pepito par l'Assistant de connexion de pepito (détail : [plugins/pepito/README.md](plugins/pepito/README.md)).

```text
/plugin marketplace add vjeantet/pepito-plugins
/plugin install pepito@pepito-plugins
```

Depuis Claude Code 2.1.275 : `/plugin install pepito --marketplace vjeantet/pepito-plugins`.

## Contenu du dépôt

- `.claude-plugin/marketplace.json` : la marketplace `pepito-plugins`.
- `plugins/pepito/` : le plugin (manifeste, skills, README d'installation).
- `docs/` et `.scratch/` : glossaire, conventions et chantiers (en français).

Licence : MIT, voir [LICENSE](LICENSE). Les skills de travail copiés sous `.claude/skills/` sont sous la licence de leur auteur ([LICENSE-mattpocock-skills](.claude/skills/LICENSE-mattpocock-skills)).
