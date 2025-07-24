#!/bin/bash

# Script to generate shell completions for Claude CLI
# Supports bash, zsh, and fish shells

set -euo pipefail

# Configuration
OUTPUT_DIR="completions"
TEMP_DIR="$(mktemp -d)"

# Find claude command
if command -v claude &> /dev/null; then
    CLAUDE_CMD="claude"
elif [ -f "$HOME/.claude/local/claude" ]; then
    CLAUDE_CMD="$HOME/.claude/local/claude"
else
    echo "Error: Claude CLI not found. Please install Claude CLI first." >&2
    exit 1
fi

# Ensure output directory exists
mkdir -p "$OUTPUT_DIR"

# Function to extract options from help output
extract_options() {
    local help_output="$1"
    echo "$help_output" | grep -E '^\s+-' | sed -E 's/^\s*(-[a-zA-Z], )?(-[a-zA-Z-]+).*/\2/' | sort -u
}

# Function to extract subcommands
extract_subcommands() {
    local help_output="$1"
    echo "$help_output" | awk '
        /^Commands:/ { in_commands = 1; next }
        /^$/ && in_commands { exit }
        in_commands && /^  [a-zA-Z]/ {
            gsub(/^[[:space:]]+/, "")
            split($0, parts, /[[:space:]]+/)
            cmd = parts[1]
            split(cmd, alias_parts, /\|/)
            print alias_parts[1]
        }
    '
}

# Generate Bash completion
generate_bash_completion() {
    echo "Generating bash completion..."
    cat > "$OUTPUT_DIR/claude.bash" << 'EOF'
# Bash completion for Claude CLI
# Generated automatically - do not edit manually

_claude() {
    local cur prev words cword
    _init_completion || return

    local commands="config mcp migrate-installer setup-token doctor update install"
    local global_opts="--help -h --version -v --continue -c --resume -r --print -p --api-key --model --permission-mode --stream"
    
    # Main command
    if [ $cword -eq 1 ]; then
        COMPREPLY=($(compgen -W "${commands} ${global_opts}" -- "${cur}"))
        return
    fi

    case "${words[1]}" in
        config)
            if [ $cword -eq 2 ]; then
                local config_subcmds="set get list remove"
                COMPREPLY=($(compgen -W "${config_subcmds}" -- "${cur}"))
            elif [ $cword -eq 3 ] && [ "${words[2]}" = "set" ]; then
                local config_keys="theme model outputdir timeout stream"
                COMPREPLY=($(compgen -W "${config_keys}" -- "${cur}"))
            fi
            ;;
        mcp)
            if [ $cword -eq 2 ]; then
                local mcp_subcmds="list add remove add-from-claude-desktop"
                COMPREPLY=($(compgen -W "${mcp_subcmds}" -- "${cur}"))
            fi
            ;;
        *)
            case "${cur}" in
                -*)
                    COMPREPLY=($(compgen -W "${global_opts}" -- "${cur}"))
                    ;;
            esac
            ;;
    esac
}

complete -F _claude claude
EOF

    echo "Bash completion generated: $OUTPUT_DIR/claude.bash"
}

# Generate Zsh completion
generate_zsh_completion() {
    echo "Generating zsh completion..."
    cat > "$OUTPUT_DIR/_claude" << 'EOF'
#compdef claude
# Zsh completion for Claude CLI
# Generated automatically - do not edit manually

_claude() {
    local -a commands
    commands=(
        'config:Manage configuration settings'
        'mcp:Manage MCP servers'
        'migrate-installer:Migrate from installer-based Claude'
        'setup-token:Set up authentication token'
        'doctor:Check Claude installation'
        'update:Update Claude CLI'
        'install:Install Claude CLI'
    )

    local -a global_options
    global_options=(
        '(-h --help)'{-h,--help}'[Show help]'
        '(-v --version)'{-v,--version}'[Show version]'
        '(-c --continue)'{-c,--continue}'[Continue last conversation]'
        '(-r --resume)'{-r,--resume}'[Resume specific session]:session ID:'
        '(-p --print)'{-p,--print}'[Print mode with prompt]:prompt:'
        '--api-key[API key]:key:'
        '--model[Model to use]:model:(claude-3-opus-20240229 claude-3-sonnet-20240229 claude-3-haiku-20240307)'
        '--permission-mode[Permission mode]:mode:(allowed plan review)'
        '--stream[Enable streaming output]'
    )

    _arguments -C \
        "${global_options[@]}" \
        '1: :->command' \
        '*::arg:->args'

    case $state in
        command)
            _describe -t commands 'claude commands' commands
            ;;
        args)
            case $words[1] in
                config)
                    _claude_config
                    ;;
                mcp)
                    _claude_mcp
                    ;;
            esac
            ;;
    esac
}

_claude_config() {
    local -a subcommands
    subcommands=(
        'set:Set a configuration value'
        'get:Get a configuration value'
        'list:List all configuration values'
        'remove:Remove a configuration value'
    )

    _arguments -C \
        '1: :->subcommand' \
        '*::arg:->args'

    case $state in
        subcommand)
            _describe -t subcommands 'config subcommands' subcommands
            ;;
        args)
            case $words[1] in
                set)
                    local -a config_keys
                    config_keys=(theme model outputdir timeout stream)
                    _arguments \
                        '(-g --global)'{-g,--global}'[Set globally]' \
                        '1:key:(${config_keys[@]})' \
                        '2:value:'
                    ;;
                get|remove)
                    local -a config_keys
                    config_keys=(theme model outputdir timeout stream)
                    _arguments '1:key:(${config_keys[@]})'
                    ;;
            esac
            ;;
    esac
}

_claude_mcp() {
    local -a subcommands
    subcommands=(
        'list:List MCP servers'
        'add:Add an MCP server'
        'remove:Remove an MCP server'
        'add-from-claude-desktop:Import servers from Claude Desktop'
    )

    _arguments -C \
        '1: :->subcommand' \
        '*::arg:->args'

    case $state in
        subcommand)
            _describe -t subcommands 'mcp subcommands' subcommands
            ;;
        args)
            case $words[1] in
                add)
                    _arguments \
                        '1:name:' \
                        '2:path:_files'
                    ;;
                remove)
                    # TODO: Complete with existing server names
                    _arguments '1:name:'
                    ;;
            esac
            ;;
    esac
}

_claude "$@"
EOF

    echo "Zsh completion generated: $OUTPUT_DIR/_claude"
}

# Generate Fish completion
generate_fish_completion() {
    echo "Generating fish completion..."
    cat > "$OUTPUT_DIR/claude.fish" << 'EOF'
# Fish completion for Claude CLI
# Generated automatically - do not edit manually

# Disable file completion by default
complete -c claude -f

# Main commands
complete -c claude -n __fish_use_subcommand -a config -d "Manage configuration settings"
complete -c claude -n __fish_use_subcommand -a mcp -d "Manage MCP servers"
complete -c claude -n __fish_use_subcommand -a migrate-installer -d "Migrate from installer-based Claude"
complete -c claude -n __fish_use_subcommand -a setup-token -d "Set up authentication token"
complete -c claude -n __fish_use_subcommand -a doctor -d "Check Claude installation"
complete -c claude -n __fish_use_subcommand -a update -d "Update Claude CLI"
complete -c claude -n __fish_use_subcommand -a install -d "Install Claude CLI"

# Global options
complete -c claude -s h -l help -d "Show help"
complete -c claude -s v -l version -d "Show version"
complete -c claude -s c -l continue -d "Continue last conversation"
complete -c claude -s r -l resume -d "Resume specific session" -x
complete -c claude -s p -l print -d "Print mode with prompt" -x
complete -c claude -l api-key -d "API key" -x
complete -c claude -l model -d "Model to use" -xa "claude-3-opus-20240229 claude-3-sonnet-20240229 claude-3-haiku-20240307"
complete -c claude -l permission-mode -d "Permission mode" -xa "allowed plan review"
complete -c claude -l stream -d "Enable streaming output"

# Config subcommands
complete -c claude -n "__fish_seen_subcommand_from config" -n "not __fish_seen_subcommand_from set get list remove" -a set -d "Set a configuration value"
complete -c claude -n "__fish_seen_subcommand_from config" -n "not __fish_seen_subcommand_from set get list remove" -a get -d "Get a configuration value"
complete -c claude -n "__fish_seen_subcommand_from config" -n "not __fish_seen_subcommand_from set get list remove" -a list -d "List all configuration values"
complete -c claude -n "__fish_seen_subcommand_from config" -n "not __fish_seen_subcommand_from set get list remove" -a remove -d "Remove a configuration value"

# Config set options
complete -c claude -n "__fish_seen_subcommand_from config; and __fish_seen_subcommand_from set" -s g -l global -d "Set globally"
complete -c claude -n "__fish_seen_subcommand_from config; and __fish_seen_subcommand_from set" -n "not __fish_seen_subcommand_from theme model outputdir timeout stream" -a "theme model outputdir timeout stream"

# MCP subcommands
complete -c claude -n "__fish_seen_subcommand_from mcp" -n "not __fish_seen_subcommand_from list add remove add-from-claude-desktop" -a list -d "List MCP servers"
complete -c claude -n "__fish_seen_subcommand_from mcp" -n "not __fish_seen_subcommand_from list add remove add-from-claude-desktop" -a add -d "Add an MCP server"
complete -c claude -n "__fish_seen_subcommand_from mcp" -n "not __fish_seen_subcommand_from list add remove add-from-claude-desktop" -a remove -d "Remove an MCP server"
complete -c claude -n "__fish_seen_subcommand_from mcp" -n "not __fish_seen_subcommand_from list add remove add-from-claude-desktop" -a add-from-claude-desktop -d "Import servers from Claude Desktop"

# Enable file completion for mcp add second argument
complete -c claude -n "__fish_seen_subcommand_from mcp; and __fish_seen_subcommand_from add" -F
EOF

    echo "Fish completion generated: $OUTPUT_DIR/claude.fish"
}

# Generate installation instructions
generate_installation_instructions() {
    cat > "$OUTPUT_DIR/README.md" << EOF
# Claude CLI Shell Completions

This directory contains shell completion files for the Claude CLI.

## Installation

### Bash

Add the following line to your \`~/.bashrc\` or \`~/.bash_profile\`:

\`\`\`bash
source /path/to/claude.bash
\`\`\`

Or copy the file to the bash completions directory:

\`\`\`bash
sudo cp claude.bash /etc/bash_completion.d/
\`\`\`

### Zsh

Copy the completion file to a directory in your \`\$fpath\`:

\`\`\`bash
# For user installation
mkdir -p ~/.zsh/completions
cp _claude ~/.zsh/completions/

# Add to ~/.zshrc if not already present
echo 'fpath=(~/.zsh/completions \$fpath)' >> ~/.zshrc
echo 'autoload -Uz compinit && compinit' >> ~/.zshrc
\`\`\`

Or for system-wide installation:

\`\`\`bash
sudo cp _claude /usr/local/share/zsh/site-functions/
\`\`\`

### Fish

Copy the completion file to the fish completions directory:

\`\`\`bash
# For user installation
cp claude.fish ~/.config/fish/completions/

# Or for system-wide installation
sudo cp claude.fish /usr/share/fish/vendor_completions.d/
\`\`\`

## Regenerating Completions

To regenerate these completion files, run:

\`\`\`bash
./scripts/generate_claude_cli_completions.sh
\`\`\`

---

*These completions are automatically generated. For the latest Claude CLI features, regenerate the completions after updating Claude CLI.*
EOF
}

# Main execution
echo "Generating Claude CLI completions..."

generate_bash_completion
generate_zsh_completion
generate_fish_completion
generate_installation_instructions

# Clean up
rm -rf "$TEMP_DIR"

echo -e "\nCompletion files generated in: $OUTPUT_DIR/"
echo "Files created:"
echo "  - $OUTPUT_DIR/claude.bash (Bash)"
echo "  - $OUTPUT_DIR/_claude (Zsh)"
echo "  - $OUTPUT_DIR/claude.fish (Fish)"
echo "  - $OUTPUT_DIR/README.md (Installation instructions)"