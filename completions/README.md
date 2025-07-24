# Claude CLI Shell Completions

This directory contains shell completion files for the Claude CLI.

## Installation

### Bash

Add the following line to your `~/.bashrc` or `~/.bash_profile`:

```bash
source /path/to/claude.bash
```

Or copy the file to the bash completions directory:

```bash
sudo cp claude.bash /etc/bash_completion.d/
```

### Zsh

Copy the completion file to a directory in your `$fpath`:

```bash
# For user installation
mkdir -p ~/.zsh/completions
cp _claude ~/.zsh/completions/

# Add to ~/.zshrc if not already present
echo 'fpath=(~/.zsh/completions $fpath)' >> ~/.zshrc
echo 'autoload -Uz compinit && compinit' >> ~/.zshrc
```

Or for system-wide installation:

```bash
sudo cp _claude /usr/local/share/zsh/site-functions/
```

### Fish

Copy the completion file to the fish completions directory:

```bash
# For user installation
cp claude.fish ~/.config/fish/completions/

# Or for system-wide installation
sudo cp claude.fish /usr/share/fish/vendor_completions.d/
```

## Regenerating Completions

To regenerate these completion files, run:

```bash
./scripts/generate_claude_cli_completions.sh
```

---

*These completions are automatically generated. For the latest Claude CLI features, regenerate the completions after updating Claude CLI.*
