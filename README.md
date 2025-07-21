# Claude Code Configuration JSON Schema

Comprehensive JSON Schema definitions for all Claude Code configuration options.

## Overview

This repository provides complete JSON Schema definitions for Claude Code configuration, enabling:
- Configuration validation
- IDE autocompletion
- Type generation
- Documentation generation

## Schema Files

| Schema | Description | Source Docs |
|--------|-------------|-------------|
| [`settings.schema.json`](schemas/settings.schema.json) | Main settings file configuration | `settings` |
| [`environment-variables.schema.json`](schemas/environment-variables.schema.json) | Environment variables | `monitoring-usage`, `setup`, `amazon-bedrock`, `google-vertex-ai`, `mcp`, `settings` |
| [`cli-flags.schema.json`](schemas/cli-flags.schema.json) | Command-line interface flags | `cli-reference` |
| [`global-config.schema.json`](schemas/global-config.schema.json) | Global configuration (`claude-code config`) | `settings`, `terminal-config` |
| [`hooks.schema.json`](schemas/hooks.schema.json) | Hooks configuration | `hooks` |
| [`permissions.schema.json`](schemas/permissions.schema.json) | Permissions configuration | `iam`, `settings` |
| [`mcp-config.schema.json`](schemas/mcp-config.schema.json) | MCP server configuration (`.mcp.json`) | `mcp` |
| [`claude-code-config.schema.json`](schemas/claude-code-config.schema.json) | Master schema referencing all options | All docs |

## Quick Start

### Installation

```bash
npm install
```

### Validate Configuration

```bash
# Validate example settings
npm run validate

# Validate your own settings
npx ajv validate -s schemas/settings.schema.json -d ~/.claude/settings.json
```

### Build Unified Schema

Generate a single schema file with all definitions inline:

```bash
npm run build
# Creates: schemas/claude-code-config.unified.schema.json
```

## Schema Organization

### 1. Modular Schemas (Default)

- **Separate files** for each configuration type
- **Benefits**: 
  - Easier maintenance
  - Partial usage support
  - Clear component separation
  - Smaller file sizes

### 2. Unified Schema

- **Single file** with all definitions inline
- **Benefits**:
  - IDE integration friendly
  - No external references
  - Simple distribution
  - One-file solution

## Schema References

### Using Remote Schemas (Recommended)

Add `$schema` to your configuration files to enable IDE validation and autocompletion:

#### Settings Files
```json
{
  "$schema": "https://raw.githubusercontent.com/mkusaka/ccconfig/main/schemas/settings.schema.json",
  "permissions": {
    "allow": ["Bash(npm run test:*)", "Read(~/.zshrc)"]
  }
}
```

#### MCP Configuration
```json
{
  "$schema": "https://raw.githubusercontent.com/mkusaka/ccconfig/main/schemas/mcp-config.schema.json",
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem"]
    }
  }
}
```

### Using Local Schemas

For offline development or custom schemas:

```json
{
  "$schema": "file:///Users/username/ccconfig/schemas/settings.schema.json",
  "permissions": {
    "allow": ["Read", "Write"]
  }
}
```

### Schema URLs

| Configuration Type | Schema URL |
|-------------------|------------|
| Settings (`settings.json`) | `https://raw.githubusercontent.com/mkusaka/ccconfig/main/schemas/settings.schema.json` |
| MCP (`.mcp.json`) | `https://raw.githubusercontent.com/mkusaka/ccconfig/main/schemas/mcp-config.schema.json` |
| Hooks | `https://raw.githubusercontent.com/mkusaka/ccconfig/main/schemas/hooks.schema.json` |
| Permissions | `https://raw.githubusercontent.com/mkusaka/ccconfig/main/schemas/permissions.schema.json` |
| All Schemas (Unified) | `https://raw.githubusercontent.com/mkusaka/ccconfig/main/schemas/claude-code-config.unified.schema.json` |

### Alternative: Using CDN

For better performance, you can use jsDelivr CDN:

```json
{
  "$schema": "https://cdn.jsdelivr.net/gh/mkusaka/ccconfig@main/schemas/settings.schema.json"
}
```

### Alternative: Schema Store (Future)

Once registered with [SchemaStore](https://www.schemastore.org/), you'll be able to use:

```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json"
}
```

## Examples

### Complete Settings Example

```json
{
  "$schema": "https://raw.githubusercontent.com/mkusaka/ccconfig/main/schemas/settings.schema.json",
  "permissions": {
    "allow": ["Bash(npm run test:*)", "Read(~/.zshrc)"],
    "deny": ["Bash(curl:*)", "Write(/etc/*)"]
  },
  "hooks": {
    "PreToolUse": [{
      "matcher": "Bash",
      "hooks": [{
        "type": "command",
        "command": "/usr/local/bin/check-bash.sh",
        "timeout": 5
      }]
    }]
  }
}
```

### Complete MCP Example

```json
{
  "$schema": "https://raw.githubusercontent.com/mkusaka/ccconfig/main/schemas/mcp-config.schema.json",
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/tmp"]
    },
    "web-api": {
      "type": "sse",
      "url": "https://api.example.com/mcp",
      "headers": {
        "Authorization": "Bearer token"
      }
    }
  }
}
```

## Configuration Hierarchy

Claude Code applies settings in the following priority order (highest to lowest):

1. **Enterprise policies** - Admin-managed settings
2. **Command line arguments** - CLI flags
3. **Local project settings** - `.claude/settings.local.json`
4. **Shared project settings** - `.claude/settings.json`
5. **User settings** - `~/.claude/settings.json`

## IDE Integration

### VS Code

Add to your workspace settings:

```json
{
  "json.schemas": [
    {
      "fileMatch": ["**/settings.json", "**/settings.local.json"],
      "url": "./schemas/settings.schema.json"
    },
    {
      "fileMatch": ["**/.mcp.json"],
      "url": "./schemas/mcp-config.schema.json"
    }
  ]
}
```

### JetBrains IDEs

1. Go to **Preferences** → **Languages & Frameworks** → **Schemas and DTDs** → **JSON Schema Mappings**
2. Add new mapping:
   - Name: `Claude Code Settings`
   - File path pattern: `**/settings.json`
   - Schema file: `path/to/schemas/settings.schema.json`

## Contributing

When updating schemas:

1. Check the latest Claude Code documentation
2. Update the relevant schema file
3. Update examples if needed
4. Run validation tests: `npm test`
5. Rebuild unified schema: `npm run build`

## License

MIT

## Related

- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)
- [JSON Schema](https://json-schema.org/)
- [Model Context Protocol](https://www.anthropic.com/news/model-context-protocol)