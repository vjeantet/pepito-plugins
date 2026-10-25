# pepito plugin for Claude Code

This plugin connects the meetings recorded by [pepito](https://pepito.sodadi.fr) to your other tools, from Claude Code. pepito records your meetings, transcribes them and writes their summaries on your Mac; the plugin does not redo that work. Its skills use pepito's local MCP server to read and enrich your recordings (notes, tags, artifacts).

**Status: skeleton.** No skill is published yet. The planned skills (`process-recording`, `session-companion`, `prepare-meeting`) are being designed in `.scratch/plugin-v1/` of this repository.

## Requirements

1. **pepito running**, installed in `/Applications` or `~/Applications`. The MCP server only exists while pepito is running.
2. **MCP server enabled** in pepito: Settings > MCP, "Access pepito from your AI tools" switch.
3. **Claude Code connected to pepito**: Settings > MCP > "Connect an AI tool…", choose Claude Code, copy the command it shows and paste it into a terminal. It looks like this:

   ```sh
   claude mcp add --scope user pepito -- <path to pepito.app>/Contents/Helpers/pepito-mcp
   ```

   Check with `claude mcp list`: `pepito` should be listed as connected. pepito never edits Claude Code's configuration itself; you run this command.

For now, the plugin assumes this connection is already set up and does not declare an MCP server of its own.

## Installation

In Claude Code:

```text
/plugin marketplace add vjeantet/pepito-plugins
/plugin install pepito@pepito-plugins
```

Or from a terminal:

```sh
claude plugin marketplace add vjeantet/pepito-plugins
claude plugin install pepito@pepito-plugins
```

Since Claude Code 2.1.275, `/plugin install pepito --marketplace vjeantet/pepito-plugins` does both in one step.

Skills are then invoked as `/pepito:<skill>`.

## Updates

Auto-update is off by default for third-party marketplaces. To turn it on: `/plugin`, Marketplaces tab, `pepito-plugins`, "Enable auto-update". Otherwise: `claude plugin update pepito@pepito-plugins`.

## Good to know

- **Lost connection**: when pepito quits or updates, the MCP connection closes and Claude Code does not restart the server. Relaunch pepito, then reconnect the server in Claude Code (`/mcp`) or start a new session.
- **Privacy**: what Claude Code reads through the MCP server (transcripts, summaries, notes) is sent to the model Claude Code uses. What a connected AI tool does with this content, including sending it to its publisher, depends on that tool.
- **Meeting content**: a transcript contains what external participants said. The skills treat it as data, never as instructions.
