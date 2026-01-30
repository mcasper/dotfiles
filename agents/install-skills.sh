#!/usr/bin/env bash
# install-skills.sh - Install coding agent skills and extensions to Claude Code, Codex, and Pi
#
# Usage:
#   ./install-skills.sh [--symlink|--copy] [--claude|--codex|--pi|--all] [--skills-only|--extensions-only]
#
# Options:
#   --symlink          Create symlinks (default, allows live editing)
#   --copy             Copy files (better for stability)
#   --claude           Install to Claude Code only
#   --codex            Install to Codex only
#   --pi               Install to Pi only
#   --all              Install to all (default)
#   --skills-only      Install skills only (skip extensions)
#   --extensions-only  Install extensions only (skip skills)

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
INSTALL_SKILLS=true
INSTALL_EXTENSIONS=true

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --symlink) MODE="symlink"; shift ;;
        --copy) MODE="copy"; shift ;;
        --claude) TARGET="claude"; shift ;;
        --codex) TARGET="codex"; shift ;;
        --pi) TARGET="pi"; shift ;;
        --all) TARGET="all"; shift ;;
        --skills-only) INSTALL_SKILLS=true; INSTALL_EXTENSIONS=false; shift ;;
        --extensions-only) INSTALL_SKILLS=false; INSTALL_EXTENSIONS=true; shift ;;
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
EXTENSIONS_SOURCE="${SCRIPT_DIR}/extensions"

# Installation paths
CLAUDE_DIR="${HOME}/.claude/skills"
CODEX_DIR="${HOME}/.codex/skills"
PI_DIR="${HOME}/.pi/agent/skills"
PI_EXTENSIONS_DIR="${HOME}/.pi/extensions"

echo -e "${BLUE}=== Agent Skills & Extensions Installer ===${NC}"
echo -e "Mode: ${MODE}"
echo -e "Target: ${TARGET}"
echo ""

if [[ "${INSTALL_SKILLS}" == true ]]; then
    echo -e "Skills source: ${SKILLS_SOURCE}"
    # Check if source directory exists
    if [[ ! -d "${SKILLS_SOURCE}" ]]; then
        echo -e "${RED}Error: Skills directory not found at ${SKILLS_SOURCE}${NC}"
        exit 1
    fi
    # Count skills
    SKILL_COUNT=$(find "${SKILLS_SOURCE}" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')
    echo -e "Found ${GREEN}${SKILL_COUNT}${NC} skills to install"
fi

if [[ "${INSTALL_EXTENSIONS}" == true ]]; then
    echo -e "Extensions source: ${EXTENSIONS_SOURCE}"
    # Check if extensions source directory exists
    if [[ -d "${EXTENSIONS_SOURCE}" ]]; then
        EXTENSION_COUNT=$(find "${EXTENSIONS_SOURCE}" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')
        echo -e "Found ${GREEN}${EXTENSION_COUNT}${NC} extensions to install"
    else
        echo -e "${YELLOW}Warning: Extensions directory not found at ${EXTENSIONS_SOURCE}${NC}"
        INSTALL_EXTENSIONS=false
    fi
fi
echo ""

install_to_claude() {
    if [[ "${INSTALL_SKILLS}" != true ]]; then
        echo -e "${YELLOW}Skipping Claude Code (extensions-only mode, Claude only supports skills)${NC}"
        return
    fi

    echo -e "${BLUE}Installing to Claude Code...${NC}"

    # Create skills directory
    mkdir -p "${CLAUDE_DIR}"

    # Install skills
    for skill_dir in "${SKILLS_SOURCE}"/*; do
        if [[ -d "${skill_dir}" ]]; then
            skill_name=$(basename "${skill_dir}")
            target_path="${CLAUDE_DIR}/${skill_name}"

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
    if [[ "${INSTALL_SKILLS}" != true ]]; then
        echo -e "${YELLOW}Skipping Codex (extensions-only mode, Codex only supports skills)${NC}"
        return
    fi

    echo -e "${BLUE}Installing to Codex...${NC}"

    # Create skills directory
    mkdir -p "${CODEX_DIR}"

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

install_to_pi() {
    echo -e "${BLUE}Installing to Pi...${NC}"

    # Install skills
    if [[ "${INSTALL_SKILLS}" == true ]]; then
        # Create skills directory
        mkdir -p "${PI_DIR}"

        for skill_dir in "${SKILLS_SOURCE}"/*; do
            if [[ -d "${skill_dir}" ]]; then
                skill_name=$(basename "${skill_dir}")
                target_path="${PI_DIR}/${skill_name}"

                # Remove existing symlink/directory
                if [[ -L "${target_path}" ]] || [[ -d "${target_path}" ]]; then
                    rm -rf "${target_path}"
                fi

                if [[ "${MODE}" == "symlink" ]]; then
                    ln -s "${skill_dir}" "${target_path}"
                    echo -e "  ${GREEN}✓${NC} Linked skill: ${skill_name}"
                else
                    cp -r "${skill_dir}" "${target_path}"
                    echo -e "  ${GREEN}✓${NC} Copied skill: ${skill_name}"
                fi
            fi
        done
        echo -e "  Skills location: ${PI_DIR}"
    fi

    # Install extensions
    if [[ "${INSTALL_EXTENSIONS}" == true ]]; then
        # Create extensions directory
        mkdir -p "${PI_EXTENSIONS_DIR}"

        for ext_dir in "${EXTENSIONS_SOURCE}"/*; do
            if [[ -d "${ext_dir}" ]]; then
                ext_name=$(basename "${ext_dir}")
                target_path="${PI_EXTENSIONS_DIR}/${ext_name}"

                # Remove existing symlink/directory
                if [[ -L "${target_path}" ]] || [[ -d "${target_path}" ]]; then
                    rm -rf "${target_path}"
                fi

                if [[ "${MODE}" == "symlink" ]]; then
                    ln -s "${ext_dir}" "${target_path}"
                    echo -e "  ${GREEN}✓${NC} Linked extension: ${ext_name}"
                else
                    cp -r "${ext_dir}" "${target_path}"
                    echo -e "  ${GREEN}✓${NC} Copied extension: ${ext_name}"
                fi
            fi
        done
        echo -e "  Extensions location: ${PI_EXTENSIONS_DIR}"
    fi

    echo -e "${GREEN}✓ Pi installation complete${NC}"
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
    pi)
        install_to_pi
        ;;
    all)
        install_to_claude
        install_to_codex
        install_to_pi
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

if [[ "${TARGET}" == "pi" ]] || [[ "${TARGET}" == "all" ]]; then
    echo -e "  ${YELLOW}Pi:${NC}"
    if [[ "${INSTALL_SKILLS}" == true ]]; then
        echo -e "    Skills are ready to use in your next session"
        echo -e "    Use /skill:name to invoke a specific skill"
    fi
    if [[ "${INSTALL_EXTENSIONS}" == true ]]; then
        echo -e "    Extensions are ready to use in your next session"
    fi
    echo ""
fi

if [[ "${MODE}" == "symlink" ]]; then
    echo -e "${BLUE}Note:${NC} Skills are symlinked - changes to source files will be reflected immediately"
else
    echo -e "${BLUE}Note:${NC} Skills are copied - run this script again to update"
fi
