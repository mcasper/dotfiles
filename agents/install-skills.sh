#!/usr/bin/env bash
# install-skills.sh - Install coding agent skills to Claude Code and Codex
#
# Usage:
#   ./install-skills.sh [--symlink|--copy] [--claude|--codex|--all]
#
# Options:
#   --symlink    Create symlinks (default, allows live editing)
#   --copy       Copy files (better for stability)
#   --claude     Install to Claude Code only
#   --codex      Install to Codex only
#   --all        Install to both (default)

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default options
MODE="symlink"
TARGET="all"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --symlink) MODE="symlink"; shift ;;
        --copy) MODE="copy"; shift ;;
        --claude) TARGET="claude"; shift ;;
        --codex) TARGET="codex"; shift ;;
        --all) TARGET="all"; shift ;;
        -h|--help)
            grep '^#' "$0" | tail -n +2 | cut -c 3-
            exit 0
            ;;
        *)
            echo -e "${RED}Error: Unknown option $1${NC}"
            exit 1
            ;;
    esac
done

# Get the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SKILLS_SOURCE="${SCRIPT_DIR}/skills"

# Installation paths
CLAUDE_DIR="${HOME}/.claude/plugins/repos/local-skills"
CODEX_DIR="${HOME}/.codex/superpowers/skills"

echo -e "${BLUE}=== Agent Skills Installer ===${NC}"
echo -e "Source: ${SKILLS_SOURCE}"
echo -e "Mode: ${MODE}"
echo -e "Target: ${TARGET}"
echo ""

# Check if source directory exists
if [[ ! -d "${SKILLS_SOURCE}" ]]; then
    echo -e "${RED}Error: Skills directory not found at ${SKILLS_SOURCE}${NC}"
    exit 1
fi

# Count skills
SKILL_COUNT=$(find "${SKILLS_SOURCE}" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')
echo -e "Found ${GREEN}${SKILL_COUNT}${NC} skills to install"
echo ""

install_to_claude() {
    echo -e "${BLUE}Installing to Claude Code...${NC}"

    # Create plugin directory structure
    mkdir -p "${CLAUDE_DIR}/skills"

    # Create plugin.json if it doesn't exist
    if [[ ! -f "${CLAUDE_DIR}/plugin.json" ]]; then
        cat > "${CLAUDE_DIR}/plugin.json" <<'EOF'
{
  "name": "local-skills",
  "description": "Personal coding agent skills library",
  "version": "1.0.0",
  "author": {
    "name": "Local User"
  },
  "keywords": ["skills", "tdd", "debugging", "collaboration"]
}
EOF
        echo -e "  ${GREEN}✓${NC} Created plugin.json"
    fi

    # Install skills
    for skill_dir in "${SKILLS_SOURCE}"/*; do
        if [[ -d "${skill_dir}" ]]; then
            skill_name=$(basename "${skill_dir}")
            target_path="${CLAUDE_DIR}/skills/${skill_name}"

            # Remove existing symlink/directory
            if [[ -L "${target_path}" ]] || [[ -d "${target_path}" ]]; then
                rm -rf "${target_path}"
            fi

            if [[ "${MODE}" == "symlink" ]]; then
                ln -s "${skill_dir}" "${target_path}"
                echo -e "  ${GREEN}✓${NC} Linked: ${skill_name}"
            else
                cp -r "${skill_dir}" "${target_path}"
                echo -e "  ${GREEN}✓${NC} Copied: ${skill_name}"
            fi
        fi
    done

    echo -e "${GREEN}✓ Claude Code installation complete${NC}"
    echo -e "  Location: ${CLAUDE_DIR}"
    echo ""
}

install_to_codex() {
    echo -e "${BLUE}Installing to Codex...${NC}"

    # Check if Codex superpowers directory exists
    if [[ ! -d "${HOME}/.codex/superpowers" ]]; then
        echo -e "${YELLOW}Warning: Codex superpowers directory not found${NC}"
        echo -e "Creating ${HOME}/.codex/superpowers/skills"
        mkdir -p "${HOME}/.codex/superpowers/skills"
    else
        mkdir -p "${CODEX_DIR}"
    fi

    # Install skills
    for skill_dir in "${SKILLS_SOURCE}"/*; do
        if [[ -d "${skill_dir}" ]]; then
            skill_name=$(basename "${skill_dir}")
            target_path="${CODEX_DIR}/${skill_name}"

            # Remove existing symlink/directory
            if [[ -L "${target_path}" ]] || [[ -d "${target_path}" ]]; then
                rm -rf "${target_path}"
            fi

            if [[ "${MODE}" == "symlink" ]]; then
                ln -s "${skill_dir}" "${target_path}"
                echo -e "  ${GREEN}✓${NC} Linked: ${skill_name}"
            else
                cp -r "${skill_dir}" "${target_path}"
                echo -e "  ${GREEN}✓${NC} Copied: ${skill_name}"
            fi
        fi
    done

    echo -e "${GREEN}✓ Codex installation complete${NC}"
    echo -e "  Location: ${CODEX_DIR}"
    echo ""
}

# Install based on target
case "${TARGET}" in
    claude)
        install_to_claude
        ;;
    codex)
        install_to_codex
        ;;
    all)
        install_to_claude
        install_to_codex
        ;;
esac

echo -e "${GREEN}=== Installation Complete ===${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"

if [[ "${TARGET}" == "claude" ]] || [[ "${TARGET}" == "all" ]]; then
    echo -e "  ${YELLOW}Claude Code:${NC}"
    echo -e "    Restart Claude Code to load the skills"
    echo -e "    Use /help to see available skills"
    echo ""
fi

if [[ "${TARGET}" == "codex" ]] || [[ "${TARGET}" == "all" ]]; then
    echo -e "  ${YELLOW}Codex:${NC}"
    echo -e "    Skills are ready to use in your next session"
    echo ""
fi

if [[ "${MODE}" == "symlink" ]]; then
    echo -e "${BLUE}Note:${NC} Skills are symlinked - changes to source files will be reflected immediately"
else
    echo -e "${BLUE}Note:${NC} Skills are copied - run this script again to update"
fi
