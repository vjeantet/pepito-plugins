# Faits Claude Code : plugins, marketplace, skills, MCP

Lecture du 2026-10-25, à l'initialisation du dépôt. Deux sources :

- **[D]** documentation officielle `code.claude.com/docs/en/…`, lue par l'agent `claude-code-guide` via WebFetch. Le texte rendu par WebFetch est retraité par un modèle : toute citation porteuse est à relire sur la page avant de servir de base à une décision (ticket [01](../tickets/01-faits-claude-code.md)).
- **[L]** constat local sur Claude Code 2.1.310 installé dans le conteneur de la session (Linux, sans pepito) : `claude --help`, `claude plugin --help`, `claude plugin validate`.

Pages : MR = `plugins/marketplace-reference`, MFR = `plugins/manifest-reference`, LOAD = `plugins/loading`, INST = `plugins/install`, HOST = `plugins/host-marketplace`, PCLI = `plugins/cli-reference`, CLI = `cli-reference`, SKILLS = `skills`, MCP = `mcp`, HEAD = `headless`.

## 1. Marketplace

- `.claude-plugin/marketplace.json` à la racine ; `name`, `owner` (`owner.name` requis) et `plugins` requis ; `description` recommandée (le validateur prévient sans elle) [D, MR].
- Nom : lettres, chiffres, `.`, `_`, `-`, commençant par une lettre ou un chiffre ; noms officiels et `claudeai-*`, `npm`, `pip`, `uv`, `cargo`, `github`, `gh` réservés [D, MR]. L'utilisateur installe `<plugin>@<nom de la marketplace>`, nom tiré du champ `name`, pas du nom du dépôt [D, HOST].
- Entrée de plugin : `name` et `source` requis ; source relative obligatoirement préfixée `./`, résolue depuis la racine de la marketplace [D, MR].
- Aucune URL `$schema` documentée [D, MR].

## 2. Manifeste du plugin

- `.claude-plugin/plugin.json`, `name` seul requis ; noms en `claude-`, `anthropic-`, `anthropics-`, `cc-plugin-` refusés [D, MFR].
- `skills/<nom>/SKILL.md` chargé par défaut, sans clé `skills` [D, MFR].
- `version` : celle du manifeste l'emporte sur celle de l'entrée de marketplace [D, MFR, MR].
- **Détection des mises à jour** : Claude Code calcule une version par plugin installé ; ordre : `version` du manifeste, puis de l'entrée, puis dérivée de la source. Pour un chemin relatif dans une marketplace hébergée sur git, la version dérivée est le SHA court du commit [D, LOAD]. Sans `version`, chaque commit est une mise à jour ; avec `version`, un commit sans changement de `version` n'est pas reçu [D, HOST].
- `claude plugin validate` signale l'absence de `version` en avertissement (« Consider adding a version following semver ») [L].

## 3. Validation

- `claude plugin validate <chemin>`, `--strict` (avertissements = erreurs), `--json` ; `/plugin validate` en session [D, PCLI] [L].
- Sur la racine du dépôt, valide la marketplace puis le `plugin.json` de chaque plugin à source relative [D] [L].
- Sur `plugins/pepito`, ajoute des « plugin directory checks » (catalogue public de plugins) : README d'au moins 40 mots (README du plugin, sinon celui de la racine du dépôt git), icône PNG carrée de 512 à 2048 px (`ICON_MISSING`) ; sans effet sur le verdict sauf `--profile directory` [L].
- Un dossier `skills/` sans skill (`.gitkeep` seul) n'est pas signalé [L].
- Constat de l'initialisation : verdict « passed with warnings » ; restent l'avertissement `version` (ticket [08](../tickets/08-distribution-versionnement.md)) et l'icône absente [L].

## 4. Skills d'un plugin

- `skills/<nom>/SKILL.md`, invoqué `/pepito:<nom>` ; `name` du frontmatter remplace le dernier segment [D, SKILLS].
- Frontmatter, tout optionnel, `description` recommandée : `name`, `description`, `when_to_use`, `argument-hint`, `arguments`, `disable-model-invocation`, `user-invocable`, `allowed-tools`, `disallowed-tools`, `model`, `effort`, `context`, `agent`, `hooks`, `paths`, `shell`, `metadata`, `license`… [D, SKILLS].
- `allowed-tools` vaut pour les skills de plugin ; il permet sans demander les outils listés pendant le tour qui invoque le skill, et la permission tombe au message suivant [D, SKILLS]. Effet en `-p` non documenté à part.
- `${CLAUDE_PLUGIN_ROOT}` et `${CLAUDE_PLUGIN_DATA}` sont substitués dans le contenu d'un skill de plugin [D, SKILLS].

## 5. Exécution non interactive

- « Include `/skill-name` in the prompt string and Claude Code expands it before running » ; en `-p`, seul le premier skill de la ligne est chargé, le reste de la ligne lui sert d'arguments [D, HEAD, SKILLS].
- Les plugins installés sont chargés en `-p` ; `--bare` les ignore ; `/plugin` ne s'exécute pas en `-p` [D, INST, HEAD].
- `--tools ""` retire tous les outils intégrés et **n'affecte pas les tools MCP** (pour les retirer : `--disallowedTools "mcp__*"`) ; `--allowedTools` permet sans demander, il ne restreint pas ; `--mcp-config`, `--strict-mcp-config`, `--plugin-dir` existent [D, CLI]. Présents dans `claude --help` 2.1.310 : `--tools`, `--allowedTools`, `--disallowedTools`, `--mcp-config`, `--strict-mcp-config`, `--plugin-dir`, `--output-format`, `--bare` ; `--max-turns` n'y apparaît pas [L].
- `claude plugin eval` existe en 2.1.310 : suites d'évaluation d'un plugin (`evals/`) [L]. Piste pour tester les skills (ticket [10](../tickets/10-redaction-publication-v1.md)).

## 6. Serveur MCP déclaré par un plugin

- `.mcp.json` à la racine du plugin, ou `mcpServers` dans `plugin.json` [D, MFR].
- Serveur enregistré `plugin:<plugin>:<serveur>` ; tools nommés `mcp__plugin_<plugin>_<serveur>__<tool>`, caractères hors `A-Za-z0-9_-` remplacés par `_` ; ce nom complet sert dans les règles de permission et `allowed-tools` [D, MCP].
- **Priorité** : local > project > user > serveurs de plugin > connecteurs claude.ai. Les doublons entre les trois portées sont repérés par **nom** ; un serveur de plugin est repéré comme doublon par **endpoint** (même commande ou même URL qu'un serveur activé au-dessus) [D, MCP]. Conséquence probable, non vérifiée : un serveur `pepito` du plugin dont la commande diffère de celle de l'utilisateur (autre emplacement de l'app) ouvre une seconde Connexion MCP, avec des tools en double sous deux préfixes. **Corrige** le fait noté le 2026-10-25 dans pepito (« la déclaration utilisateur l'emporte » sans condition).
- `${CLAUDE_PLUGIN_ROOT}`, `${CLAUDE_PLUGIN_DATA}`, `${CLAUDE_PROJECT_DIR}` substitués dans `command`, `args`, `env` d'un serveur stdio [D, MCP].
- Commande au chemin absolu hors du plugin (`/Applications/pepito.app/Contents/Helpers/pepito-mcp`) : non documentée [D].
- Plugin activé en portée project : ses serveurs MCP passent par la même approbation qu'un `.mcp.json` de projet [D, LOAD].

## 7. Installation et mise à jour

- `/plugin marketplace add owner/repo` ou `claude plugin marketplace add owner/repo` (`#ref`, `@ref` acceptés), portée user par défaut ; `/plugin install pepito@pepito-plugins` ou `claude plugin install …` ; en une étape : `/plugin install pepito --marketplace owner/repo` (2.1.275+), `claude plugin install pepito --marketplace owner/repo` (2.1.292+) [D, INST, PCLI].
- Mise à jour automatique désactivée par défaut pour toute marketplace autre qu'officielle ; activable par `/plugin` > Marketplaces > « Enable auto-update », ou `autoUpdate` sur l'entrée `extraKnownMarketplaces` ; en arrière-plan après le premier message, délai aléatoire jusqu'à dix minutes. À la main : `claude plugin update pepito@pepito-plugins` [D, INST, LOAD].
- Cache d'installation : `cache/<marketplace>/<plugin>/<version>/` ; non présenté comme stable, donc pepito ni un Script de post-traitement ne doivent y pointer [D, LOAD].

## Non documenté

- URL `$schema` des manifestes.
- Commande MCP au chemin absolu hors du plugin.
- Serveur utilisateur de même nom mais d'autre commande : masque-t-il celui du plugin ?
- Rôle d'un `README.md` de plugin (absent de la liste des composants, lu par les « plugin directory checks » [L]).

## À vérifier sur le Mac de l'utilisateur (avec pepito)

Repris par le ticket [01](../tickets/01-faits-claude-code.md) : expansion de `/pepito:<skill>` en `-p` ; `allowed-tools` en `-p` avec `mcp__pepito__*` ; doublon par endpoint ; Relais MCP lancé par un `claude -p` enfant de pepito ; noms préfixés réels.
