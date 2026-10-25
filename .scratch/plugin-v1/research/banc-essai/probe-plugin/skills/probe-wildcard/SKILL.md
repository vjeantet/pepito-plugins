---
name: probe-wildcard
description: Test skill that reads one recording from pepito.
disable-model-invocation: true
allowed-tools: mcp__pepito__*
---

Call the pepito MCP tool get_recording with id "$ARGUMENTS". Then reply with exactly the text the tool returned, prefixed by "RESULT: ". If the tool is unavailable or denied, reply "DENIED: " followed by the reason.
