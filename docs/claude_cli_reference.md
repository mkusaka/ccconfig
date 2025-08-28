# Claude CLI Complete Command Reference

This document provides a comprehensive overview of all Claude CLI commands and their options.

Generated on: 2025-08-28 00:18:08 UTC
Claude CLI Version: 1.0.93 (Claude Code)

---

## Table of Contents

1. [Main Command](#main-command)
2. [Config Commands](#config-commands)
3. [MCP Commands](#mcp-commands)
4. [Utility Commands](#utility-commands)
5. [Usage Examples](#usage-examples)

---

## Main Command

### `claude`

```
Usage: claude [options] [command] [prompt]

Claude Code - starts an interactive session by default, use -p/--print for
non-interactive output

Arguments:
  prompt                                            Your prompt

Options:
  -d, --debug [filter]                              Enable debug mode with optional category filtering (e.g., "api,hooks" or "!statsig,!file")
  --verbose                                         Override verbose mode setting from config
  -p, --print                                       Print response and exit (useful for pipes)
  --output-format <format>                          Output format (only works with --print): "text" (default), "json" (single result), or "stream-json" (realtime streaming) (choices: "text", "json", "stream-json")
  --input-format <format>                           Input format (only works with --print): "text" (default), or "stream-json" (realtime streaming input) (choices: "text", "stream-json")
  --mcp-debug                                       [DEPRECATED. Use --debug instead] Enable MCP debug mode (shows MCP server errors)
  --dangerously-skip-permissions                    Bypass all permission checks. Recommended only for sandboxes with no internet access.
  --replay-user-messages                            Re-emit user messages from stdin back on stdout for acknowledgment (only works with --input-format=stream-json and --output-format=stream-json)
  --allowedTools, --allowed-tools <tools...>        Comma or space-separated list of tool names to allow (e.g. "Bash(git:*) Edit")
  --disallowedTools, --disallowed-tools <tools...>  Comma or space-separated list of tool names to deny (e.g. "Bash(git:*) Edit")
  --mcp-config <configs...>                         Load MCP servers from JSON files or strings (space-separated)
  --append-system-prompt <prompt>                   Append a system prompt to the default system prompt
  --permission-mode <mode>                          Permission mode to use for the session (choices: "acceptEdits", "bypassPermissions", "default", "plan")
  -c, --continue                                    Continue the most recent conversation
  -r, --resume [sessionId]                          Resume a conversation - provide a session ID or interactively select a conversation to resume
  --model <model>                                   Model for the current session. Provide an alias for the latest model (e.g. 'sonnet' or 'opus') or a model's full name (e.g. 'claude-sonnet-4-20250514').
  --fallback-model <model>                          Enable automatic fallback to specified model when default model is overloaded (only works with --print)
  --settings <file-or-json>                         Path to a settings JSON file or a JSON string to load additional settings from
  --add-dir <directories...>                        Additional directories to allow tool access to
  --ide                                             Automatically connect to IDE on startup if exactly one valid IDE is available
  --strict-mcp-config                               Only use MCP servers from --mcp-config, ignoring all other MCP configurations
  --session-id <uuid>                               Use a specific session ID for the conversation (must be a valid UUID)
  -v, --version                                     Output the version number
  -h, --help                                        Display help for command

Commands:
  config                                            Manage configuration (eg. claude config set -g theme dark)
  mcp                                               Configure and manage MCP servers
  migrate-installer                                 Migrate from global npm installation to local installation
  setup-token                                       Set up a long-lived authentication token (requires Claude subscription)
  doctor                                            Check the health of your Claude Code auto-updater
  update                                            Check for updates and install if available
  install [options] [target]                        Install Claude Code native build. Use [target] to specify version (stable, latest, or specific version)
```

## Config Commands

### `claude config`

```
Usage: claude config [options] [command]

Manage configuration (eg. claude config set -g theme dark)

Options:
  -h, --help                             Display help for command

Commands:
  get [options] <key>                    Get a config value
  set [options] <key> <value>            Set a config value
  remove|rm [options] <key> [values...]  Remove a config value or items from a config array
  list|ls [options]                      List all config values
  add [options] <key> <values...>        Add items to a config array (space or comma separated)
  help [command]                         display help for command
```

#### `claude config get`

```
Usage: claude config get [options] <key>

Get a config value

Options:
  -g, --global  Use global config
  -h, --help    Display help for command
```

#### `claude config set`

```
Usage: claude config set [options] <key> <value>

Set a config value

Options:
  -g, --global  Use global config
  -h, --help    Display help for command
```

#### `claude config remove`

```
Usage: claude config remove|rm [options] <key> [values...]

Remove a config value or items from a config array

Options:
  -g, --global  Use global config
  -h, --help    Display help for command
```

#### `claude config list`

```
Usage: claude config list|ls [options]

List all config values

Options:
  -g, --global  Use global config (default: false)
  -h, --help    Display help for command
```

#### `claude config add`

```
Usage: claude config add [options] <key> <values...>

Add items to a config array (space or comma separated)

Options:
  -g, --global  Use global config
  -h, --help    Display help for command
```

#### `claude config help`

```
Usage: claude config [options] [command]

Manage configuration (eg. claude config set -g theme dark)

Options:
  -h, --help                             Display help for command

Commands:
  get [options] <key>                    Get a config value
  set [options] <key> <value>            Set a config value
  remove|rm [options] <key> [values...]  Remove a config value or items from a config array
  list|ls [options]                      List all config values
  add [options] <key> <values...>        Add items to a config array (space or comma separated)
  help [command]                         display help for command
```

## MCP Commands

### `claude mcp`

```
Usage: claude mcp [options] [command]

Configure and manage MCP servers

Options:
  -h, --help                                     Display help for command

Commands:
  serve [options]                                Start the Claude Code MCP server
  add [options] <name> <commandOrUrl> [args...]  Add a server
  remove [options] <name>                        Remove an MCP server
  list                                           List configured MCP servers
  get <name>                                     Get details about an MCP server
  add-json [options] <name> <json>               Add an MCP server (stdio or SSE) with a JSON string
  add-from-claude-desktop [options]              Import MCP servers from Claude Desktop (Mac and WSL only)
  reset-project-choices                          Reset all approved and rejected project-scoped (.mcp.json) servers within this project
  help [command]                                 display help for command
```

#### `claude mcp serve`

```
Usage: claude mcp serve [options]

Start the Claude Code MCP server

Options:
  -d, --debug  Enable debug mode
  --verbose    Override verbose mode setting from config
  -h, --help   Display help for command
```

#### `claude mcp add`

```
Usage: claude mcp add [options] <name> <commandOrUrl> [args...]

Add a server

Options:
  -s, --scope <scope>          Configuration scope (local, user, or project)
                               (default: "local")
  -t, --transport <transport>  Transport type (stdio, sse, http) (default:
                               "stdio")
  -e, --env <env...>           Set environment variables (e.g. -e KEY=value)
  -H, --header <header...>     Set WebSocket headers (e.g. -H "X-Api-Key:
                               abc123" -H "X-Custom: value")
  -h, --help                   Display help for command
```

#### `claude mcp remove`

```
Usage: claude mcp remove [options] <name>

Remove an MCP server

Options:
  -s, --scope <scope>  Configuration scope (local, user, or project) - if not
                       specified, removes from whichever scope it exists in
  -h, --help           Display help for command
```

#### `claude mcp list`

```
Usage: claude mcp list [options]

List configured MCP servers

Options:
  -h, --help  Display help for command
```

#### `claude mcp get`

```
Usage: claude mcp get [options] <name>

Get details about an MCP server

Options:
  -h, --help  Display help for command
```

#### `claude mcp add-json`

```
Usage: claude mcp add-json [options] <name> <json>

Add an MCP server (stdio or SSE) with a JSON string

Options:
  -s, --scope <scope>  Configuration scope (local, user, or project) (default:
                       "local")
  -h, --help           Display help for command
```

#### `claude mcp add-from-claude-desktop`

```
Usage: claude mcp add-from-claude-desktop [options]

Import MCP servers from Claude Desktop (Mac and WSL only)

Options:
  -s, --scope <scope>  Configuration scope (local, user, or project) (default:
                       "local")
  -h, --help           Display help for command
```

#### `claude mcp reset-project-choices`

```
Usage: claude mcp reset-project-choices [options]

Reset all approved and rejected project-scoped (.mcp.json) servers within this
project

Options:
  -h, --help  Display help for command
```

#### `claude mcp help`

```
Usage: claude mcp [options] [command]

Configure and manage MCP servers

Options:
  -h, --help                                     Display help for command

Commands:
  serve [options]                                Start the Claude Code MCP server
  add [options] <name> <commandOrUrl> [args...]  Add a server
  remove [options] <name>                        Remove an MCP server
  list                                           List configured MCP servers
  get <name>                                     Get details about an MCP server
  add-json [options] <name> <json>               Add an MCP server (stdio or SSE) with a JSON string
  add-from-claude-desktop [options]              Import MCP servers from Claude Desktop (Mac and WSL only)
  reset-project-choices                          Reset all approved and rejected project-scoped (.mcp.json) servers within this project
  help [command]                                 display help for command
```

## Utility Commands

### `claude migrate-installer`

```
Usage: claude migrate-installer [options]

Migrate from global npm installation to local installation

Options:
  -h, --help  Display help for command
```

### `claude setup-token`

```
Usage: claude setup-token [options]

Set up a long-lived authentication token (requires Claude subscription)

Options:
  -h, --help  Display help for command
```

### `claude doctor`

```
Usage: claude doctor [options]

Check the health of your Claude Code auto-updater

Options:
  -h, --help  Display help for command
```

### `claude update`

```
Usage: claude update [options]

Check for updates and install if available

Options:
  -h, --help  Display help for command
```

### `claude install`

```
Usage: claude install [options] [target]

Install Claude Code native build. Use [target] to specify version (stable,
latest, or specific version)

Options:
  --force     Force installation even if already installed
  -h, --help  Display help for command
```

## Usage Examples

### Basic Usage

```bash
# Start interactive session
claude

# Print mode with prompt
claude -p "Write a hello world in Python"

# Continue last conversation
claude -c

# Resume specific session
claude -r <session-id>

# Use specific model
claude --model opus "Complex reasoning task"
```

### Configuration Management

```bash
# Set configuration values
claude config set theme dark
claude config set -g model sonnet

# Get configuration values
claude config get theme
claude config list

# Remove configuration
claude config remove theme
```

### MCP Server Management

```bash
# List MCP servers
claude mcp list

# Add MCP server
claude mcp add myserver /path/to/server

# Remove MCP server
claude mcp remove myserver

# Import from Claude Desktop
claude mcp add-from-claude-desktop
```

### Session Management

```bash
# Continue the last conversation
claude --continue

# Resume a specific session
claude --resume abc123-def456

# Start with specific permission mode
claude --permission-mode plan
```

---

*This documentation is automatically generated. For the latest information, run `claude --help`.*
