# Vérification des faits Claude Code sur la documentation brute

Lecture du 2026-10-25. Pages récupérées en Markdown brut par `curl -sS https://code.claude.com/docs/en/<page>.md` (toutes en 200), sans WebFetch : les citations ci-dessous sont recopiées telles quelles. Elles vérifient les sections 1 à 7 de [faits-claude-code.md](faits-claude-code.md) (ticket [01](../tickets/01-faits-claude-code.md)). Les constats locaux [L] de ce fichier ne sont pas revus ici.

Abréviations de pages, toutes sous `https://code.claude.com/docs/en/` : MR = `plugins/marketplace-reference`, MFR = `plugins/manifest-reference`, LOAD = `plugins/loading`, INST = `plugins/install`, HOST = `plugins/host-marketplace`, PCLI = `plugins/cli-reference`, COMP = `plugins/components`, CLI = `cli-reference`, SKILLS = `skills`, MCP = `mcp`, HEAD = `headless`, PERM = `permissions`, SETREF = `settings-reference`.

## 1. Marketplace

**Champs requis — confirmé.** MR, « Top-level fields » : « `name`, `owner`, and `plugins` are required. » ; `owner` : « `name` is required; `email` and `url` are optional » ; `description` : « `claude plugin validate` warns when it's missing ». MR, « Plugin entries » : « `name` and `source` are required. »

**Source relative en `./` — confirmé, avec deux exceptions.** MR, « Plugin sources » : « Must start with `./`, unless you write a [bare name under `metadata.pluginRoot`](#relative-path-plugin-source). `"."` on its own means the root itself ». MR, « Relative path plugin source » : « The path resolves from the marketplace root. » et « A path containing `..` fails validation. »

**Noms réservés — précisé (liste incomplète dans faits).** MR, « Reserved names » réserve aussi les noms communautaires (`claude-community`, `claude-plugins-community`, `healthcare`), ceux de l'annuaire (`anthropic-plugin-directory`, `claude-plugin-directory`), les variantes d'orthographe d'un nom réservé (« a name that differs from a reserved name only by a trailing dot, or by a symbol other than an underscore in place of a hyphen »), ainsi que `inline`, `builtin`, `skills-dir`, `synced` et `claude-plugin-test`. Citations conservées : « **`npm`, `pip`, `uv`, `cargo`, `github`, and `gh`**: reserved in any casing. » ; « **Names starting with `claudeai-`**: reserved for marketplaces hosted on claude.ai. » `pepito-plugins` n'est concerné par aucune de ces règles.

**`$schema` — précisé.** Le champ existe, mais aucune URL n'est donnée. MR, « Top-level fields » : « `$schema` | string | JSON Schema URL for editor autocomplete. Ignored at load time ». MFR, « Fields » : « JSON Schema URL for editor autocomplete. Claude Code ignores it at load time ».

**Identifiant d'installation — confirmé, et précisé pour la partie plugin.** HOST, « Host your marketplace » : « Claude Code takes that name from the `name` field in your `marketplace.json`, not from the repository name. » Pour la partie avant `@`, MR, « Plugin entries » : « Users type it before `@` when they install, even when the plugin's own `plugin.json` sets a different `name` ». LOAD, « Entry name and manifest name » : le nom d'entrée est « the install and enable key », et le `name` du manifeste est « what the plugin's components are namespaced under ».

## 2. Manifeste du plugin

**`name` seul requis — confirmé ; le manifeste est lui-même optionnel.** MFR, « Fields » : « `name` is the only required key. » MFR, « Standard layout » : « Manifest | `.claude-plugin/plugin.json` | Plugin metadata and configuration. Optional ».

**Préfixes `claude-` et autres — corrigé : refusés par l'outillage, pas au chargement.** MFR, « `name` » : « Starts with `claude-`, `anthropic-`, `anthropics-`, or `cc-plugin-` | Error » puis « `claude plugin init` and `claude plugin tag` refuse a name that draws the error. Claude Code still installs and loads a plugin whose name they refuse. »

**`skills/` chargé par défaut — confirmé.** MFR, « Standard layout » : « Skills | `skills/` | One `<name>/SKILL.md` per skill. » MFR, « How each key combines with its default location » : « **Adds to the default**: `skills`. The `skills/` directory is still scanned ».

**Priorité de `version` — confirmé.** MFR, « Metadata precedence » : « **`version`**: the manifest's `version` overrides the entry's ». HOST, « Release a new version » : « If you do, Claude Code uses the `plugin.json` value without warning, and `claude plugin validate` reports the mismatch as `Entry declares version "<a>" but <path>/plugin.json says "<b>"`. »

**Version dérivée pour une source relative — corrigé : la doc ne parle pas de SHA court.** LOAD, « How Claude Code computes the version », dans le tableau : « Relative path inside a Git-hosted marketplace | The commit SHA of the installed directory ». Seules les sources `github`, `url` et `git-subdir` sont décrites ainsi : « The commit SHA of the source, shortened to 12 characters ». La doc ne dit pas si un commit qui ne touche pas `plugins/pepito/` change la version.

**Commits non reçus quand `version` ne change pas — confirmé (citation exacte).** HOST, « Release a new version » : « **Bump `version` on each release**: users stay on their cached copy until the string changes. If you set `"version": "1.0.0"` and push new commits without changing it, users don't receive them. » puis « **Omit `version`**: users track your commits instead. Leave `version` out of both `plugin.json` and the marketplace entry. »

## 3. `claude plugin validate`

**Options — confirmé.** PCLI, « plugin validate » : « `--strict` | Treat warnings as errors, so unrecognized fields and missing metadata that the runtime tolerates fail the run » ; « `--json` | Output the validation report as one JSON object with the same exit codes. Requires Claude Code v2.1.259 or later ». En session, PCLI, « /plugin in a session » : « `/plugin validate <path>` | | Prints the same report as `claude plugin validate`, inline ». `--profile directory` n'est pas documenté : c'est un constat local [L].

**Validation depuis la racine — précisé.** La validation de la marketplace couvre bien le `plugin.json` des plugins (MR, « Validation messages » : « A message prefixed with an entry index and `plugin.json →`, such as `plugins[2] plugin.json →`, is about that plugin's own files. »). En revanche, elle n'ouvre ni les skills ni les fichiers MCP. PCLI, « Validate a directory » : « **Plugin files in a marketplace run**: from a marketplace directory, Claude Code doesn't open the skill, agent, command, or hook files of plugins the marketplace lists in other directories, or the MCP server files they bundle. To find errors in those files, validate each plugin directory ». La convention du CLAUDE.md, qui valide aussi `plugins/pepito`, reste donc nécessaire.

## 4. Skills d'un plugin

**Nommage `/plugin:skill` — confirmé, avec un ajout.** COMP, « Skills » : « **Command name**: `/<plugin>:<directory>` ... If you set `name` in the frontmatter, it replaces the last segment and the plugin prefix stays. » Ajout, SKILLS, « How a skill gets its command name » : « The bare `/fancy` also invokes the skill unless another command already uses that name. »

**Frontmatter — confirmé, avec deux champs à ajouter.** SKILLS, « Frontmatter reference » : « All fields are optional. Only `description` is recommended so Claude knows when to use the skill. » Le tableau contient aussi `background` (« Only applies with `context: fork` ») et `compatibility`, absents de la liste de faits. Autre citation : « Claude Code ignores a field it doesn't recognize without reporting an error. »

**Ce que donne `allowed-tools` — confirmé (citation exacte).** SKILLS, « Pre-approve tools for a skill » : « The `allowed-tools` field grants permission for the listed tools during the turn that invokes the skill, so Claude can use them without prompting you for approval. The grant clears when you send your next message, even though the skill content stays in context; invoking the skill again re-applies it for that turn. It does not restrict which tools are available: every tool remains callable, and your permission settings still govern tools that are not listed. »

**`allowed-tools` dans un skill de plugin — non documenté explicitement, mais impliqué.** Aucune phrase ne dit qu'il s'applique aux skills de plugin. Deux indices :
- MCP, « Plugin-provided MCP servers » : « Use this full name when referencing the tool in permission rules, a skill's `allowed-tools` list, a subagent's `tools` field, or a hook matcher. »
- SETREF, « `allowManagedPermissionRulesOnly` » : la liste des sources dont `allowed-tools` est ignoré sous cette politique ne nomme pas les plugins de marketplace, seulement les plugins sous `.claude/skills/` et ceux en `@inline`.

**`allowed-tools` en `-p` — corrigé : c'est documenté, pour les skills de projet.** SKILLS, « Pre-approve tools for a skill » : « Workspace trust doesn't gate this field. Claude Code applies a project skill's `allowed-tools` even in a `-p` run in a folder you've never trusted. » Rien n'est dit sur un skill de plugin en `-p`.

**Jokers MCP — documentés pour les règles de permission, pas pour `allowed-tools`.** PERM, « MCP » : « `mcp__puppeteer` matches any tool provided by the `puppeteer` server » / « `mcp__puppeteer__*` uses wildcard syntax and also matches all tools from the `puppeteer` server » / « `mcp__puppeteer__puppeteer_navigate` matches the `puppeteer_navigate` tool provided by the `puppeteer` server ». PERM, « Tool name wildcards » : « Allow rules accept tool-name globs only after a literal `mcp__<server>__` prefix. ... An unanchored allow glob such as `"*"`, `"B*"`, or `"mcp__*"` is skipped and doesn't auto-approve anything. » Les exemples de SKILLS n'utilisent que `Bash(...)` : un joker `mcp__pepito__*` dans `allowed-tools` reste à vérifier sur le Mac.

## 5. Exécution non interactive

**Expansion de `/skill-name` — confirmé (citation exacte).** HEAD, note sous « Create a commit » : « User-invoked skills and custom commands work. Include `/skill-name` in the prompt string and Claude Code expands it before running. »

**Un seul skill chargé — confirmé.** SKILLS, « Stack several skills in one message » : « Through the Agent SDK or `claude -p`, Claude Code loads only the first skill, with the rest of the line as its arguments. »

**Plugins en `-p` — confirmé, avec une condition pour la portée projet.** INST, « JetBrains, non-interactive runs, and the Agent SDK » : « **`claude -p` and other non-interactive runs**: `/plugin` doesn't run, and Claude replies `/plugin isn't available in this environment.` Plugins you already installed do load. » Condition à ajouter, LOAD, « Trust check and component limits for repository plugins » : « it loads only after the same trust check that applies to project allow rules in `.claude/settings.json`. Trusting a parent folder or running with `-p` isn't enough. » La portée par défaut, user, n'est pas concernée.

**`--bare` — confirmé.** HEAD, « Start faster with bare mode » : « Add `--bare` to reduce startup time by skipping auto-discovery of hooks, skills, custom commands, subagents, installed plugins, MCP servers, auto memory, and CLAUDE.md. Without it, `claude -p` discovers and loads them as an interactive session would ». Un plugin se charge alors avec « `--plugin-dir <path>`, `--plugin-url <url>` ». HEAD ajoute : « `--bare` is the recommended mode for scripted and SDK calls, and will become the default for `-p` in a future release. »

## 6. Options de la CLI (CLI, « CLI flags »)

- `--tools` — confirmé : « Restrict which built-in tools Claude can use. Use `""` to disable all, `"default"` for the default set, or tool names like `"Bash,Edit,Read"`. ... The flag doesn't affect MCP tools; to deny those too, use `--disallowedTools "mcp__*"`. »
- `--allowedTools` — confirmé : « Tools that execute without prompting for permission, apart from reads from network paths. See permission rule syntax for pattern matching. To restrict which tools are available, use `--tools` instead. »
- `--disallowedTools` : « Deny rules. A bare tool name removes the matching tools from Claude's context: `"Edit"` removes Edit, `"*"` removes every tool, and `"mcp__*"` removes every MCP tool. A scoped rule such as `Bash(rm *)` leaves the tool available and denies only calls that match as written. »
- `--mcp-config` : « Load MCP servers from JSON files or strings (space-separated). When you pass this flag with `-p`, Claude Code waits for still-pending servers to connect before running the first turn, up to the `MCP_TIMEOUT` startup timeout, 30 seconds by default ».
- `--strict-mcp-config` : « Only use MCP servers from `--mcp-config`, ignoring all other MCP configurations. »
- `--plugin-dir` : « Load a plugin from a directory or `.zip` archive, or several from a folder of plugins, for this session only. Each flag takes one path. »
- `--max-turns` — documenté, alors que `claude --help` 2.1.310 ne l'affiche pas [L] : « Limit the number of agentic turns (print mode only). Exits with an error when the limit is reached. No limit by default. »
- `--permission-mode` : « Accepts `default`, `acceptEdits`, `plan`, `auto`, `dontAsk`, `bypassPermissions`, or `manual` as an alias for `default`. »
- `--output-format` : « Specify output format for print mode (options: `text`, `json`, `stream-json`) ».

**Tool qui demande une permission en `-p` — documenté : l'appel est refusé, la session continue.** HEAD, « Auto-approve tools » : « Calls to tools you didn't list run if they need no approval. In a Manual mode `claude -p` run, a call that needs approval is denied unless something approves it, such as a `PermissionRequest` hook or a `--permission-prompt-tool`. With Claude Code v2.1.302 or later, `claude -p` runs start in Manual mode when nothing sets a permission mode. » HEAD, « Turn off permission prompts in unattended runs » : « In a `-p` run with no host, these requests are denied either way » et « With `--output-format stream-json`, denials appear as `permission_denied` system messages, and the final result message lists them in `permission_denials`. »

## 7. Serveur MCP déclaré par un plugin

**Nommage des tools — confirmé.** MCP, « Plugin-provided MCP servers » : « The full form is `mcp__plugin_<plugin-name>_<server-name>__<tool-name>`, where any character outside `A-Z`, `a-z`, `0-9`, `_`, and `-` is replaced with `_`. » et « The server itself registers under the scoped name `plugin:<plugin-name>:<server-name>` ». PERM, « MCP » : « for the `database-tools` server in a plugin named `my-plugin`, write `mcp__plugin_my-plugin_database-tools__*` ».

**Ordre de priorité — confirmé.** MCP, « Scope hierarchy and precedence » : « 1. Local scope 2. Project scope 3. User scope 4. Plugin-provided servers 5. claude.ai connectors ». Un serveur d'organisation se place au-dessus : « A server your organization provides through the `managedMcpServers` managed setting ranks above all of these ».

**Détection des doublons — confirmé. Paragraphes entiers, MCP, « Scope hierarchy and precedence » :**

> « When the same server is defined in more than one place, Claude Code connects to it once, using the definition from the highest-precedence source. The entire server entry from that source is used; fields are not merged across scopes. »
>
> « Claude Code matches duplicates across the three scopes by name. It matches plugins and connectors by endpoint, so one that points at the same URL or command as an enabled server above counts as a duplicate. »
>
> « Two URL spellings count as the same endpoint when they differ only in the letter case of the scheme or host, the scheme's default port, such as `:443` on `https`, or a trailing slash. A different path, query string, userinfo, or non-default port makes two servers. »

Ce que la doc ne dit pas :
- si « same ... command » compare aussi `args` et `env` ;
- ce qui se passe quand les commandes diffèrent. Le double raccordement reste une déduction.

Sur les définitions de même nom entre portées, MCP, « Configuration warnings » : « if you define the same server name in more than one scope with different endpoints, Claude Code warns about the conflict in `claude mcp list` output and in `/mcp`. »

**`command` au chemin absolu hors du plugin — non documenté (confirmé).** La règle de confinement porte sur les chemins de composants, pas sur `command`. LOAD, « Paths that escape the plugin directory » : « It rejects a component path that resolves outside the plugin root ». MFR, « Path rules » : « Every component path in a manifest is relative to the plugin root and must start with `./`. » Indice indirect : l'exemple de COMP, « MCP servers », utilise `"command": "node"`, une commande prise dans le `PATH` et non dans le plugin.

**Substitution de variables — confirmé et complété.** MCP, « Plugin-provided MCP servers » : « `${CLAUDE_PLUGIN_ROOT}` resolves to the plugin's installation directory, `${CLAUDE_PLUGIN_DATA}` to its persistent state directory, and `${CLAUDE_PROJECT_DIR}` to the stable project root. Substitution applies to: `stdio` servers: `command`, `args`, `env` ». Variables exportées au processus, MFR, « Where each variable resolves » : « MCP `stdio` servers | `command`, `args`, `env` | `CLAUDE_PLUGIN_ROOT`, `CLAUDE_PLUGIN_DATA` ». `CLAUDE_PROJECT_DIR` n'est donc pas exporté au serveur. MCP, « Environment variable expansion in `.mcp.json` », accepte aussi `${VAR}` et `${VAR:-default}`, l'exemple de plugin utilisant `"DB_URL": "${DB_URL}"`.

**Plugin en portée project — confirmé.** LOAD, « Trust check and component limits for repository plugins » : « MCP servers it declares go through the same per-server approval as a project `.mcp.json` ».

## 8. Installation et mise à jour

**Commandes et `owner/repo#ref` — confirmé.** PCLI, « plugin marketplace add » : « `owner/repo`, `owner/repo#ref`, or `owner/repo@ref` | `github` | Clones the GitHub repository, pinned to `ref` when given. » ; « `--scope <scope>` | ... Defaults to `user` ». PCLI, « plugin install » : « `--marketplace <source>` | Install `<plugin>`, given by its bare name, from the marketplace at `<source>`, adding the marketplace first if you haven't added it yet. ... Requires Claude Code v2.1.292 or later ». En session, INST, « Add and install in a session » : « Requires Claude Code v2.1.275 or later. »

**Mise à jour automatique désactivée par défaut — confirmé.** INST, « Keep plugins updated » : « **Off by default**: every other marketplace, including the community marketplace, third-party marketplaces, and local development marketplaces. » HOST, « Turn on auto-update » : « Background auto-update is off for your marketplace by default, and `marketplace.json` has no field to turn it on. »

**Activation — confirmé.** LOAD, « Which marketplaces and plugins auto-update » : « **`autoUpdate` on its `extraKnownMarketplaces` entry** in a settings file » puis « **`autoUpdate` on its `known_marketplaces.json` entry**, which the **Enable auto-update** toggle under `/plugin` **Marketplaces** writes ».

**Moment de la mise à jour automatique — précisé : uniquement en session interactive.** LOAD, « When auto-update runs » : « In an interactive session, after you send your first message, Claude Code waits a random delay of up to ten minutes. » Un `claude -p` ne déclenche donc pas cette passe d'après la doc.

**`claude plugin update` — confirmé.** HOST, « Turn on auto-update » : « Without auto-update, users receive your changes when they run `/plugin marketplace update <name>` in a session or `claude plugin update <plugin>@<name>` in the shell. » PCLI, « plugin update » : « The new version loads in your next session, or after you run `/reload-plugins` in a running one. »

**Cache — précisé.** La doc ne dit pas que le cache est « instable ». Elle donne deux raisons concrètes de ne pas y pointer :
- MFR, « Environment variables » : « `${CLAUDE_PLUGIN_ROOT}` changes when the plugin updates, so don't write state there. »
- LOAD, « Cleanup of previous versions » : « It removes that directory in a background cleanup 14 days later ».

Par ailleurs, la racine des plugins se déplace avec `CLAUDE_CODE_PLUGIN_CACHE_DIR` (LOAD, « Find plugins on disk »).

## Écarts relevés dans faits-claude-code.md

1. § 1 : la liste des noms réservés est incomplète (noms communautaires, de l'annuaire, variantes d'orthographe, `inline`/`builtin`/`skills-dir`/`synced`/`claude-plugin-test`).
2. § 1 et « Non documenté » : le champ `$schema` est documenté dans les deux manifestes (accepté, ignoré au chargement) ; seule l'URL manque.
3. § 2 : les noms en `claude-`, `anthropic-`, etc. ne sont pas « refusés » au chargement. Ils sont refusés par `validate` (erreur), `init` et `tag`, mais « Claude Code still installs and loads » le plugin.
4. § 2 : pour une source relative, la doc dit « The commit SHA of the installed directory », pas « SHA court ». Le raccourci à 12 caractères ne vaut que pour `github`, `url` et `git-subdir`. On ne sait pas si un commit hors de `plugins/pepito/` change la version.
5. § 2 : le manifeste `plugin.json` est lui-même optionnel.
6. § 3 : depuis la racine, la validation n'ouvre pas les skills ni les fichiers MCP des plugins. Seule la validation de `plugins/pepito` les contrôle.
7. § 4 : `background` et `compatibility` manquent dans la liste du frontmatter.
8. § 4 : que `allowed-tools` « vaut pour les skills de plugin » n'est pas écrit dans SKILLS. C'est impliqué par MCP (« a skill's `allowed-tools` list ») et par SETREF.
9. § 4 : l'effet de `allowed-tools` en `-p` est documenté pour les skills de projet (« even in a `-p` run in a folder you've never trusted »), mais pas pour les skills de plugin.
10. § 4 : la syntaxe à joker MCP n'est documentée que pour les règles de permission, pas pour `allowed-tools`.
11. § 5 : `--max-turns` est documenté dans `cli-reference` (« print mode only »), même s'il n'apparaît pas dans `--help` 2.1.310.
12. § 5 : un plugin en portée projet ne se charge en `-p` qu'après la vérification de confiance (« running with `-p` isn't enough »).
13. § 5 : en `-p`, un appel qui demande une permission est refusé, en mode Manual par défaut depuis v2.1.302 ; ce comportement manquait dans faits.
14. § 6 : la doc ne dit pas si la comparaison « same ... command » inclut `args` et `env`. `CLAUDE_PROJECT_DIR` est substitué dans la configuration mais pas exporté au processus du serveur stdio.
15. § 7 : la mise à jour automatique ne se lance qu'« In an interactive session ». Pour le cache, la doc donne des raisons précises (la racine change à chaque mise à jour, l'ancienne version est supprimée 14 jours plus tard) au lieu de dire qu'il n'est pas stable.
