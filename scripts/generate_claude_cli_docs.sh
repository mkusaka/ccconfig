#!/bin/bash

# Script to generate comprehensive Claude CLI documentation
# This script recursively explores all Claude CLI commands and generates a markdown reference

set -euo pipefail

# Configuration
OUTPUT_FILE="docs/claude_cli_reference.md"
TEMP_DIR="$(mktemp -d)"
EXPLORED_COMMANDS="$TEMP_DIR/explored_commands.txt"

# Find claude command
if command -v claude &> /dev/null; then
    CLAUDE_CMD="claude"
elif [ -f "$HOME/.claude/local/claude" ]; then
    CLAUDE_CMD="$HOME/.claude/local/claude"
else
    echo "Error: Claude CLI not found. Please install Claude CLI first." >&2
    exit 1
fi

# Ensure docs directory exists
mkdir -p "$(dirname "$OUTPUT_FILE")"

# Initialize the output file
cat > "$OUTPUT_FILE" << EOF
# Claude CLI Complete Command Reference

This document provides a comprehensive overview of all Claude CLI commands and their options.

Generated on: $(date -u +"%Y-%m-%d %H:%M:%S UTC")
Claude CLI Version: $($CLAUDE_CMD --version 2>/dev/null || echo "unknown")

---

## Table of Contents

1. [Main Command](#main-command)
2. [Config Commands](#config-commands)
3. [MCP Commands](#mcp-commands)
4. [Utility Commands](#utility-commands)
5. [Usage Examples](#usage-examples)

---

EOF

# Function to clean up command output
clean_output() {
    # Remove ANSI color codes and other control characters
    sed -E 's/\x1B\[[0-9;]*[JKmsu]//g' | \
    sed 's/\r//g'
}

# Function to extract subcommands from help output
extract_subcommands() {
    local help_output="$1"
    
    # Look for the "Commands:" section and extract command names
    echo "$help_output" | awk '
        /^Commands:/ { in_commands = 1; next }
        /^$/ && in_commands { exit }
        in_commands && /^  [a-zA-Z]/ {
            # Extract command name (first word after spaces)
            gsub(/^[[:space:]]+/, "")
            # Handle commands with aliases like "remove|rm"
            split($0, parts, /[[:space:]]+/)
            cmd = parts[1]
            split(cmd, alias_parts, /\|/)
            print alias_parts[1]
        }
    '
}

# Function to explore a command
explore_command() {
    local command_path="$1"
    local section_name="$2"
    local header_level="$3"
    
    # Generate the section header
    local header=""
    for ((i=0; i<header_level; i++)); do
        header="${header}#"
    done
    
    echo -e "\n$header $section_name\n" >> "$OUTPUT_FILE"
    
    # Get help output
    local help_output
    help_output=$(eval "$CLAUDE_CMD ${command_path#claude} --help" 2>&1 | clean_output || true)
    
    # Add the help output
    echo '```' >> "$OUTPUT_FILE"
    echo "$help_output" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    
    # Return the help output for further processing
    echo "$help_output"
}

# Main exploration
echo "Generating Claude CLI documentation..."

echo "## Main Command" >> "$OUTPUT_FILE"
main_help=$(explore_command "" "\`claude\`" 3)

# Config commands
echo -e "\n## Config Commands" >> "$OUTPUT_FILE"
config_help=$(explore_command "config" "\`claude config\`" 3)

# Extract and explore config subcommands
config_subcmds=$(extract_subcommands "$config_help")
while IFS= read -r subcmd; do
    if [ -n "$subcmd" ]; then
        echo "  Exploring: claude config $subcmd" >&2
        explore_command "config $subcmd" "\`claude config $subcmd\`" 4
    fi
done <<< "$config_subcmds"

# MCP commands
echo -e "\n## MCP Commands" >> "$OUTPUT_FILE"
mcp_help=$(explore_command "mcp" "\`claude mcp\`" 3)

# Extract and explore MCP subcommands
mcp_subcmds=$(extract_subcommands "$mcp_help")
while IFS= read -r subcmd; do
    if [ -n "$subcmd" ]; then
        echo "  Exploring: claude mcp $subcmd" >&2
        explore_command "mcp $subcmd" "\`claude mcp $subcmd\`" 4
    fi
done <<< "$mcp_subcmds"

# Utility commands
echo -e "\n## Utility Commands" >> "$OUTPUT_FILE"

utility_commands=(
    "migrate-installer"
    "setup-token"
    "doctor"
    "update"
    "install"
)

for cmd in "${utility_commands[@]}"; do
    echo "  Exploring: claude $cmd" >&2
    explore_command "$cmd" "\`claude $cmd\`" 3
done

# Add usage examples section
echo -e "\n## Usage Examples\n" >> "$OUTPUT_FILE"
cat >> "$OUTPUT_FILE" << 'EOF'
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
EOF

# Clean up
rm -rf "$TEMP_DIR"

echo "Documentation generated in: $OUTPUT_FILE"
echo "Total size: $(wc -l < "$OUTPUT_FILE") lines"