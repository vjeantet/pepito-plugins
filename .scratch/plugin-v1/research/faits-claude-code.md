# Faits Claude Code : plugins, marketplace, skills, MCP

Fiche de référence du chantier, établie le 2026-10-25 (ticket [01](../tickets/01-faits-claude-code.md)). Marqueurs :

- **[D]** documentation officielle `code.claude.com/docs/en/<page>.md`, lue en Markdown brut (curl, sans retraitement) ; citations exactes, page et section dans [verification-doc-2026-10-25.md](verification-doc-2026-10-25.md) ;
- **[L]** essai sur Claude Code 2.1.310 dans le conteneur de la session (Linux, sans pepito), avec le faux serveur MCP « pepito » du [banc d'essai](banc-essai/) ; configuration isolée par `CLAUDE_CONFIG_DIR` pour les essais de portée user ;
- **[Mac]** à vérifier sur le Mac de l'utilisateur avec le vrai pepito : ticket [11](../tickets/11-essais-mac-pepito.md).

Pages : MR = `plugins/marketplace-reference`, MFR = `plugins/manifest-reference`, LOAD = `plugins/loading`, INST = `plugins/install`, HOST = `plugins/host-marketplace`, PCLI = `plugins/cli-reference`, COMP = `plugins/components`, CLI = `cli-reference`, SKILLS = `skills`, MCP = `mcp`, HEAD = `headless`, PERM = `permissions`, SETREF = `settings-reference`.

## 1. Marketplace

- `.claude-plugin/marketplace.json` ; `name`, `owner` (`owner.name` requis) et `plugins` requis ; `description` recommandée, `claude plugin validate` prévient sans elle [D, MR].
- Entrée de plugin : `name` et `source` requis ; source relative préfixée `./` (ou nom nu sous `metadata.pluginRoot`), résolue depuis la racine de la marketplace, `..` refusé [D, MR].
- Noms réservés : noms officiels, communautaires et de l'annuaire, `claudeai-*`, `npm`, `pip`, `uv`, `cargo`, `github`, `gh` (toute casse), `inline`, `builtin`, `skills-dir`, `synced`, `claude-plugin-test`, et leurs variantes d'orthographe ; `pepito-plugins` n'est pas concerné [D, MR].
- Identifiant d'installation `<entrée>@<marketplace>` : la marketplace est nommée par le champ `name`, pas par le dépôt ; la partie avant `@` est le `name` de l'entrée, les composants sont préfixés par le `name` du manifeste [D, HOST, MR, LOAD]. Constaté : `pepito@pepito-plugins` [L].
- `$schema` accepté et ignoré au chargement dans les deux manifestes ; aucune URL documentée [D, MR, MFR].

## 2. Manifeste du plugin

- `.claude-plugin/plugin.json`, lui-même optionnel ; `name` seul requis [D, MFR].
- Noms en `claude-`, `anthropic-`, `anthropics-`, `cc-plugin-` : erreur de `validate`, refusés par `claude plugin init` et `tag`, mais installés et chargés quand même [D, MFR].
- `skills/<nom>/SKILL.md` lu par défaut, sans clé `skills` [D, MFR].
- `version` du manifeste l'emporte sur celle de l'entrée ; une divergence est signalée par `validate` [D, MFR, HOST].
- **Version et mises à jour** :
  - sans `version`, la version d'une source relative dans une marketplace git est « the commit SHA of the installed directory » [D, LOAD] ; constaté : SHA court de 12 caractères du **dernier commit du dépôt**, pas du dernier commit touchant `plugins/pepito/` : un commit qui ne modifie que `.scratch/` est livré comme mise à jour (`claude plugin update` : « updated from 274af78db8d2 to 5ae17fecb94a ») [L] ;
  - avec `version`, « If you set "version": "1.0.0" and push new commits without changing it, users don't receive them » [D, HOST] ; constaté : changement de README sans hausse de `version`, « already at the latest version (0.1.0) » [L].
- `claude plugin validate` avertit quand `version` manque [L].

## 3. Validation

- `claude plugin validate <chemin>`, `--strict`, `--json` ; `/plugin validate` en session [D, PCLI].
- Depuis la racine, valide la marketplace et le `plugin.json` de chaque plugin à source relative, mais n'ouvre ni les skills ni les fichiers MCP : valider aussi `plugins/pepito` [D, PCLI].
- Sur un dossier de plugin, ajoute des « plugin directory checks » (catalogue public) : README d'au moins 40 mots (celui du plugin, sinon celui de la racine du dépôt), licence (fichier ou `license`), icône PNG carrée de 512 à 2048 px ; sans effet sur le verdict sauf `--profile directory` [L].
- Ne signale pas un `skills/` sans skill, ni une commande MCP au chemin absolu hors du plugin [L].

## 4. Skills d'un plugin

- Invoqués `/<plugin>:<dossier>` ; un `name` de frontmatter remplace le dernier segment ; `/<skill>` nu marche aussi sauf conflit [D, COMP, SKILLS].
- Frontmatter, tout optionnel, `description` recommandée : `name`, `description`, `when_to_use`, `argument-hint`, `arguments`, `disable-model-invocation`, `user-invocable`, `allowed-tools`, `disallowed-tools`, `model`, `effort`, `context`, `agent`, `background`, `hooks`, `paths`, `shell`, `metadata`, `license`, `compatibility` ; champ inconnu ignoré sans erreur [D, SKILLS].
- `allowed-tools` « grants permission for the listed tools during the turn that invokes the skill… The grant clears when you send your next message… It does not restrict which tools are available » [D, SKILLS]. Son application aux skills de plugin n'est écrite nulle part dans SKILLS, seulement impliquée (MCP : « a skill's `allowed-tools` list ») [D].
- **Constaté en `-p`** avec un skill de plugin chargé par `--plugin-dir` et le serveur `pepito` de `--mcp-config` [L] :
  - sans `allowed-tools`, l'appel `mcp__pepito__get_recording` est refusé, listé dans `permission_denials`, et le skill le rapporte ;
  - `allowed-tools: mcp__pepito__get_recording` ou `allowed-tools: mcp__pepito__*` : appel permis sans `--allowedTools`.
  - même résultat avec le skill d'un plugin **installé** depuis une marketplace (`claude plugin install`, sans `--plugin-dir`) et `allowed-tools: mcp__pepito__*` ; le même appel demandé hors du skill est refusé.
- Joker MCP documenté pour les règles de permission seulement : `mcp__pepito`, `mcp__pepito__*`, `mcp__pepito__<tool>` ; un joker non ancré (`mcp__*`) n'autorise rien [D, PERM].
- `${CLAUDE_PLUGIN_ROOT}` et `${CLAUDE_PLUGIN_DATA}` substitués dans le contenu d'un skill de plugin [D, SKILLS].

## 5. Exécution non interactive

- « Include `/skill-name` in the prompt string and Claude Code expands it before running » ; un seul skill par ligne, le reste sert d'arguments [D, HEAD, SKILLS]. Constaté : `claude -p "/pepito:probe-allowed rec-123"` développe le skill et transmet `rec-123` à `$ARGUMENTS` [L].
- Plugins installés chargés en `-p` (portée user ; en portée project, seulement après la vérification de confiance du dossier) ; `--bare` ignore plugins et serveurs MCP découverts, et deviendra le défaut de `-p` « in a future release » [D, INST, LOAD, HEAD]. **À suivre** : le jour où `--bare` sera le défaut, un Script de post-traitement devra passer `--plugin-dir` ou `--mcp-config` explicitement.
- Permissions : depuis 2.1.302, `-p` démarre en mode Manual ; un appel qui demande une approbation est refusé sauf hook `PermissionRequest` ou `--permission-prompt-tool`, la session continue, les refus sont listés dans `permission_denials` [D, HEAD] [L]. Options utiles à un appel sans humain : `--permission-mode dontAsk` (refuse tout ce qui demanderait), `--permission-prompts none` (dit à Claude de ne pas réessayer) [D, HEAD].
- `--tools ""` retire les outils intégrés et n'affecte pas les tools MCP ; `--disallowedTools "mcp__*"` les retire ; `--allowedTools` permet sans demander, ne restreint pas [D, CLI]. Constaté : avec `--tools ""`, le shell est absent, les trois tools du faux serveur restent, et un skill de plugin est encore développé et exécuté [L].
- `--max-turns` documenté (« print mode only ») mais absent de `claude --help` 2.1.310 [D, CLI] [L].
- `--mcp-config`, `--strict-mcp-config`, `--plugin-dir`, `--output-format`, `--permission-mode` existent [D, CLI]. Constaté : `--strict-mcp-config` écarte aussi le serveur déclaré par un plugin [L].
- La mise à jour automatique ne tourne qu'en session interactive ; un `claude -p` ne la déclenche pas [D, LOAD].

## 6. Serveur MCP déclaré par un plugin

- `.mcp.json` à la racine du plugin, ou `mcpServers` dans `plugin.json` [D, MFR].
- Serveur `plugin:<plugin>:<serveur>`, tools `mcp__plugin_<plugin>_<serveur>__<tool>` [D, MCP]. Constaté : `mcp__plugin_pepito_pepito__get_recording` [L].
- **Doublons** : « Claude Code matches duplicates across the three scopes by name. It matches plugins and connectors by endpoint, so one that points at the same URL or command as an enabled server above counts as a duplicate » [D, MCP]. Constaté avec un serveur `pepito` en portée user (`claude mcp add --scope user pepito -- <cmd>`) et un serveur `pepito` dans le `.mcp.json` du plugin [L] :

  | Plugin par rapport à la déclaration user | Processus lancés | Tools visibles |
  |---|---|---|
  | même commande, mêmes `args` | 1 | `mcp__pepito__*` seuls |
  | même commande et `args`, `env` différent | 1 | `mcp__pepito__*` seuls |
  | même commande, `args` différents | 2 | `mcp__pepito__*` et `mcp__plugin_pepito_pepito__*` |
  | autre commande | 2 | `mcp__pepito__*` et `mcp__plugin_pepito_pepito__*` |

  L'endpoint comparé est donc la commande avec ses `args`, sans `env`. Avec pepito, deux Connexions MCP vers le même pepito, chacune visible dans Settings > MCP [Mac].
- Commande au chemin absolu hors du plugin : non documentée [D] ; acceptée au chargement par `--plugin-dir`, sans avertissement de `validate` [L]. Commande absente du disque : serveur `failed` dans l'événement `init` (`mcp_servers`), session poursuivie, rien dans `plugin_errors` [L].
- `${CLAUDE_PLUGIN_ROOT}`, `${CLAUDE_PLUGIN_DATA}`, `${CLAUDE_PROJECT_DIR}` substitués dans `command`, `args`, `env` ; seuls les deux premiers sont exportés au processus ; `${VAR}` et `${VAR:-défaut}` acceptés [D, MCP, MFR].
- Plugin activé en portée project : ses serveurs passent par l'approbation d'un `.mcp.json` de projet [D, LOAD].

## 7. Installation et mise à jour

- `/plugin marketplace add owner/repo` ou `claude plugin marketplace add owner/repo` (`#ref`, `@ref`), portée user par défaut ; `/plugin install pepito@pepito-plugins` ou `claude plugin install …` ; en une étape : `/plugin install pepito --marketplace owner/repo` (2.1.275+), `claude plugin install … --marketplace owner/repo` (2.1.292+) [D, INST, PCLI]. Constaté : `claude plugin marketplace add 'vjeantet/pepito-plugins#claude/init-depot-plugin'` puis `claude plugin install pepito@pepito-plugins` réussissent, version `e524a639d3c4` [L].
- Mise à jour automatique désactivée par défaut pour toute marketplace tierce ; `marketplace.json` n'a aucun champ pour l'activer ; activation par `/plugin` > Marketplaces > « Enable auto-update » (écrit `autoUpdate` dans `known_marketplaces.json`) ou `autoUpdate` sur l'entrée `extraKnownMarketplaces` d'un fichier de réglages [D, INST, HOST, LOAD]. Constaté : aucune clé `autoUpdate` après un `marketplace add` [L].
- À la main : `/plugin marketplace update <nom>` ou `claude plugin update pepito@pepito-plugins` ; nouvelle version chargée à la session suivante ou après `/reload-plugins` [D, HOST, PCLI] [L].
- Cache `cache/<marketplace>/<plugin>/<version>/` : `${CLAUDE_PLUGIN_ROOT}` change à chaque mise à jour et l'ancienne version est supprimée 14 jours plus tard ; ni pepito ni un Script de post-traitement ne doivent y pointer [D, MFR, LOAD].

## Non documenté

- URL `$schema` des manifestes.
- Commande MCP au chemin absolu hors du plugin (acceptée en pratique, [L]).
- Application d'`allowed-tools` aux skills de plugin et joker MCP dans `allowed-tools` (vérifiés en pratique sur un plugin installé, [L]).

## Reste à vérifier sur le Mac (ticket 11)

- Un `claude -p` lancé par un processus enfant de pepito joint pepito par le Relais MCP (question partagée avec `script-post-traitement#08` de pepito).
- Avec le vrai Relais MCP : noms `mcp__pepito__*`, doublon entre la commande de l'Assistant de connexion et un `.mcp.json` de plugin, deux Connexions MCP visibles dans Settings > MCP.
