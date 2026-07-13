# Coding Agent Skills

This directory contains coding agent skills and configurations for AI-powered development tools.

## Structure

```
agents/
├── AGENTS.md            # Shared global agent instructions
├── skills/              # Skill definitions for coding agents
│   ├── fetch-ci-build/
│   ├── nano-banana-pro/
│   ├── semantic-commit/
│   └── sentry-issue/
├── prompts/             # Pi prompt templates
├── install-skills.sh    # Installation script for Claude Code, Codex, and Pi
└── README.md            # This file
```

## Skills

This directory contains four standalone skills:

- **fetch-ci-build**: Fetch and diagnose GitHub Actions, Buildkite, and CircleCI failures
- **nano-banana-pro**: Generate and edit images with Gemini 3.1 Flash Image
- **semantic-commit**: Create commits that follow the Conventional Commits specification
- **sentry-issue**: Investigate Sentry issues with `sentry-cli` and the Sentry API

## Installation

Use the provided script to install skills to your coding agents:

### Quick Start

Install to Claude Code, Codex, and Pi:
```bash
./agents/install-skills.sh
```

### Options

```bash
# Install to specific platform
./agents/install-skills.sh --claude
./agents/install-skills.sh --codex
./agents/install-skills.sh --pi

# Choose installation method
./agents/install-skills.sh --symlink  # Default: allows live editing
./agents/install-skills.sh --copy     # Copies files for stability

# Install Pi prompt templates only
./agents/install-skills.sh --pi --prompts-only

# Combine options
./agents/install-skills.sh --copy --claude
./agents/install-skills.sh --symlink --pi
```

### Installation Modes

**Symlink (Default)**: Creates symbolic links to the source files. Changes you make are immediately reflected in installed skills/extensions/instructions. Best for development.

**Copy**: Copies files to installation locations. More stable but requires re-running the script to update. Best for production use.

### Pi Prompt Templates

Pi prompt templates are managed from `agents/prompts/*.md` and installed to `~/.pi/agent/prompts` when targeting Pi. Use `--prompts-only` to install only prompt templates.

### Global Instructions File

The installer also manages the shared top-level instruction file from `agents/AGENTS.md`:

- **Pi**: `~/.pi/agent/AGENTS.md`
- **Codex**: `~/.codex/AGENTS.md`
- **Claude Code**: `~/.claude/CLAUDE.md`

## Usage

### Claude Code

After installation:
1. Restart Claude Code
2. Skills will be automatically available
3. Use `/help` to see available skills
4. Global instructions are synced to `~/.claude/CLAUDE.md`

### Codex

Skills are automatically loaded in your next Codex session.
Global instructions are synced to `~/.codex/AGENTS.md`.

### Pi

After installation:
1. Start a new Pi session
2. Skills are discovered automatically at startup
3. Use `/skill:name` to invoke a specific skill (e.g., `/skill:fetch-ci-build`)
4. Use prompt templates by typing `/template-name` (e.g., `/dummy`)
5. Pi shows available skills when relevant to your task
6. Global instructions are synced to `~/.pi/agent/AGENTS.md`

## Updating

To update skills after making changes:

**If using symlinks**: Changes are automatically reflected
**If using copy mode**: Re-run the installation script
