# Coding Agent Skills

This directory contains coding agent skills and configurations for AI-powered development tools.

## Structure

```
agents/
├── skills/              # Skill definitions for coding agents
│   ├── brainstorming/
│   ├── systematic-debugging/
│   ├── test-driven-development/
│   └── ...
├── install-skills.sh    # Installation script for Claude Code and Codex
└── README.md           # This file
```

## Skills

The skills in this directory are based on [obra/superpowers](https://github.com/obra/superpowers), modified to remove git worktree dependencies. These skills provide structured workflows for:

- **Testing**: Test-driven development, verification patterns
- **Debugging**: Systematic debugging, root cause analysis
- **Collaboration**: Brainstorming, code reviews, planning
- **Meta**: Writing new skills, documentation

## Installation

Use the provided script to install skills to your coding agents:

### Quick Start

Install to both Claude Code and Codex:
```bash
./agents/install-skills.sh
```

### Options

```bash
# Install to specific platform
./agents/install-skills.sh --claude
./agents/install-skills.sh --codex

# Choose installation method
./agents/install-skills.sh --symlink  # Default: allows live editing
./agents/install-skills.sh --copy     # Copies files for stability

# Combine options
./agents/install-skills.sh --copy --claude
```

### Installation Modes

**Symlink (Default)**: Creates symbolic links to the skills directory. Changes you make to skills are immediately reflected in both agents. Best for development.

**Copy**: Copies skill files to the installation locations. More stable but requires re-running the script to update. Best for production use.

## Usage

### Claude Code

After installation:
1. Restart Claude Code
2. Skills will be automatically available
3. Use `/help` to see available skills

### Codex

Skills are automatically loaded in your next Codex session.

## Updating

To update skills after making changes:

**If using symlinks**: Changes are automatically reflected
**If using copy mode**: Re-run the installation script

## Modifications

This skills collection differs from the original superpowers repository:
- Removed `using-git-worktrees` skill
- Removed all references to git worktrees from other skills
- Streamlined workflow to work with standard git branches

## Credits

Skills based on [Superpowers](https://github.com/obra/superpowers) by Jesse Vincent.
