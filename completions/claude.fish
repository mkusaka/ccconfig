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
