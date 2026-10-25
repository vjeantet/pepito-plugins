# pepito-plugins

Claude Code marketplace for the **pepito** plugin. [pepito](https://pepito.sodadi.fr) is a macOS app that records your meetings, transcribes them and writes their summaries on your Mac. The `pepito` plugin gives Claude Code skills that connect these meetings to your other tools, through pepito's local MCP server. It contains no code from the app.

**Status: skeleton.** No skill is published yet.

## Quick install

Requirements: pepito running, MCP server enabled in Settings > MCP, Claude Code connected to pepito with pepito's connection assistant (details: [plugins/pepito/README.md](plugins/pepito/README.md)).

```text
/plugin marketplace add vjeantet/pepito-plugins
/plugin install pepito@pepito-plugins
```

Since Claude Code 2.1.275: `/plugin install pepito --marketplace vjeantet/pepito-plugins`.

## Repository contents

- `.claude-plugin/marketplace.json`: the `pepito-plugins` marketplace.
- `plugins/pepito/`: the plugin (manifest, skills, installation README).
- `docs/` and `.scratch/`: maintainers' working notes (glossary, conventions, design tickets), written in French.

License: MIT, see [LICENSE](LICENSE). The development skills copied under `.claude/skills/` are under their author's license ([LICENSE-mattpocock-skills](.claude/skills/LICENSE-mattpocock-skills)).
