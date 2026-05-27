#!/usr/bin/env bash
# install-skills.sh - Install coding agent skills, extensions, prompt templates, and global instructions to Claude Code, Codex, and Pi
#
# Usage:
#   ./install-skills.sh [--symlink|--copy] [--claude|--codex|--pi|--all] [--skills-only|--extensions-only|--prompts-only]
#
# Options:
#   --symlink          Create symlinks (default, allows live editing)
#   --copy             Copy files (better for stability)
#   --claude           Install to Claude Code only
#   --codex            Install to Codex only
#   --pi               Install to Pi only
#   --all              Install to all (default)
#   --skills-only      Install skills only (skip extensions and prompts)
#   --extensions-only  Install extensions only (skip skills and prompts)
#   --prompts-only     Install Pi prompt templates only (skip skills, extensions, and instructions)

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
INSTALL_PROMPTS=true
INSTALL_INSTRUCTIONS=true
PROMPTS_ONLY=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --symlink) MODE="symlink"; shift ;;
        --copy) MODE="copy"; shift ;;
        --claude) TARGET="claude"; shift ;;
        --codex) TARGET="codex"; shift ;;
        --pi) TARGET="pi"; shift ;;
        --all) TARGET="all"; shift ;;
        --skills-only) INSTALL_SKILLS=true; INSTALL_EXTENSIONS=false; INSTALL_PROMPTS=false; INSTALL_INSTRUCTIONS=true; PROMPTS_ONLY=false; shift ;;
        --extensions-only) INSTALL_SKILLS=false; INSTALL_EXTENSIONS=true; INSTALL_PROMPTS=false; INSTALL_INSTRUCTIONS=true; PROMPTS_ONLY=false; shift ;;
        --prompts-only) INSTALL_SKILLS=false; INSTALL_EXTENSIONS=false; INSTALL_PROMPTS=true; INSTALL_INSTRUCTIONS=false; PROMPTS_ONLY=true; shift ;;
        -h|--help)
            rg '^#' "$0" | tail -n +2 | cut -c 3-
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
PROMPTS_SOURCE="${SCRIPT_DIR}/prompts"
AGENTS_SOURCE="${SCRIPT_DIR}/AGENTS.md"

# Installation paths
CLAUDE_DIR="${HOME}/.claude/skills"
CODEX_DIR="${HOME}/.codex/skills"
PI_DIR="${HOME}/.pi/agent/skills"
PI_EXTENSIONS_DIR="${HOME}/.pi/agent/extensions"
PI_PROMPTS_DIR="${HOME}/.pi/agent/prompts"
CLAUDE_AGENT_FILE="${HOME}/.claude/CLAUDE.md"
CODEX_AGENT_FILE="${HOME}/.codex/AGENTS.md"
PI_AGENT_FILE="${HOME}/.pi/agent/AGENTS.md"

echo -e "${BLUE}=== Agent Skills, Extensions & Prompt Templates Installer ===${NC}"
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
    SKILL_COUNT=0
    for skill_dir in "${SKILLS_SOURCE}"/*; do
        if [[ -d "${skill_dir}" ]]; then
            SKILL_COUNT=$((SKILL_COUNT + 1))
        fi
    done
    echo -e "Found ${GREEN}${SKILL_COUNT}${NC} skills to install"
fi

if [[ "${INSTALL_EXTENSIONS}" == true ]]; then
    echo -e "Extensions source: ${EXTENSIONS_SOURCE}"
    # Check if extensions source directory exists
    if [[ -d "${EXTENSIONS_SOURCE}" ]]; then
        DIR_COUNT=0
        for ext_dir in "${EXTENSIONS_SOURCE}"/*; do
            if [[ -d "${ext_dir}" ]]; then
                DIR_COUNT=$((DIR_COUNT + 1))
            fi
        done

        FILE_COUNT=0
        for ext_file in "${EXTENSIONS_SOURCE}"/*.ts; do
            if [[ -f "${ext_file}" ]]; then
                FILE_COUNT=$((FILE_COUNT + 1))
            fi
        done

        EXTENSION_COUNT=$((DIR_COUNT + FILE_COUNT))
        echo -e "Found ${GREEN}${EXTENSION_COUNT}${NC} extensions to install"
    else
        echo -e "${YELLOW}Warning: Extensions directory not found at ${EXTENSIONS_SOURCE}${NC}"
        INSTALL_EXTENSIONS=false
    fi
fi

if [[ "${PROMPTS_ONLY}" == true ]] && { [[ "${TARGET}" == "claude" ]] || [[ "${TARGET}" == "codex" ]]; }; then
    echo -e "${RED}Error: Prompt templates are only supported for Pi. Use --pi or --all with prompt options.${NC}"
    exit 1
fi

if [[ "${INSTALL_PROMPTS}" == true ]] && { [[ "${TARGET}" == "pi" ]] || [[ "${TARGET}" == "all" ]]; }; then
    echo -e "Prompt templates source: ${PROMPTS_SOURCE}"
    if [[ ! -d "${PROMPTS_SOURCE}" ]]; then
        echo -e "${RED}Error: Prompt templates directory not found at ${PROMPTS_SOURCE}${NC}"
        exit 1
    fi

    PROMPT_COUNT=0
    for prompt_file in "${PROMPTS_SOURCE}"/*.md; do
        if [[ -f "${prompt_file}" ]]; then
            PROMPT_COUNT=$((PROMPT_COUNT + 1))
        fi
    done
    echo -e "Found ${GREEN}${PROMPT_COUNT}${NC} Pi prompt templates to install"
fi

if [[ "${INSTALL_INSTRUCTIONS}" == true ]]; then
    if [[ ! -f "${AGENTS_SOURCE}" ]]; then
        echo -e "${RED}Error: AGENTS.md not found at ${AGENTS_SOURCE}${NC}"
        exit 1
    fi

    echo -e "Agent instructions source: ${AGENTS_SOURCE}"
fi

echo ""

install_instruction_file() {
    local source_path="$1"
    local target_path="$2"
    local label="$3"

    mkdir -p "$(dirname "${target_path}")"

    if [[ -L "${target_path}" ]] || [[ -f "${target_path}" ]]; then
        rm -f "${target_path}"
    fi

    if [[ "${MODE}" == "symlink" ]]; then
        ln -s "${source_path}" "${target_path}"
        echo -e "  ${GREEN}✓${NC} Linked ${label}: ${target_path}"
    else
        cp "${source_path}" "${target_path}"
        echo -e "  ${GREEN}✓${NC} Copied ${label}: ${target_path}"
    fi
}

install_to_claude() {
    echo -e "${BLUE}Installing to Claude Code...${NC}"

    # Install skills
    if [[ "${INSTALL_SKILLS}" == true ]]; then
        # Create skills directory
        mkdir -p "${CLAUDE_DIR}"

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
        echo -e "  Skills location: ${CLAUDE_DIR}"
    else
        echo -e "  ${YELLOW}Skipping skills (extensions-only mode)${NC}"
    fi

    if [[ "${INSTALL_INSTRUCTIONS}" == true ]]; then
        install_instruction_file "${AGENTS_SOURCE}" "${CLAUDE_AGENT_FILE}" "global instructions"
    fi

    echo -e "${GREEN}✓ Claude Code installation complete${NC}"
    echo ""
}

install_to_codex() {
    echo -e "${BLUE}Installing to Codex...${NC}"

    # Install skills
    if [[ "${INSTALL_SKILLS}" == true ]]; then
        # Create skills directory
        mkdir -p "${CODEX_DIR}"

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
        echo -e "  Skills location: ${CODEX_DIR}"
    else
        echo -e "  ${YELLOW}Skipping skills (extensions-only mode)${NC}"
    fi

    if [[ "${INSTALL_INSTRUCTIONS}" == true ]]; then
        install_instruction_file "${AGENTS_SOURCE}" "${CODEX_AGENT_FILE}" "global instructions"
    fi

    echo -e "${GREEN}✓ Codex installation complete${NC}"
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

        # Install directory-based extensions
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

        # Install single-file extensions (.ts files)
        for ext_file in "${EXTENSIONS_SOURCE}"/*.ts; do
            if [[ -f "${ext_file}" ]]; then
                ext_name=$(basename "${ext_file}")
                target_path="${PI_EXTENSIONS_DIR}/${ext_name}"

                # Remove existing symlink/file
                if [[ -L "${target_path}" ]] || [[ -f "${target_path}" ]]; then
                    rm -f "${target_path}"
                fi

                if [[ "${MODE}" == "symlink" ]]; then
                    ln -s "${ext_file}" "${target_path}"
                    echo -e "  ${GREEN}✓${NC} Linked extension: ${ext_name}"
                else
                    cp "${ext_file}" "${target_path}"
                    echo -e "  ${GREEN}✓${NC} Copied extension: ${ext_name}"
                fi
            fi
        done
        echo -e "  Extensions location: ${PI_EXTENSIONS_DIR}"
    fi

    # Install prompt templates
    if [[ "${INSTALL_PROMPTS}" == true ]]; then
        mkdir -p "${PI_PROMPTS_DIR}"

        for prompt_file in "${PROMPTS_SOURCE}"/*.md; do
            if [[ -f "${prompt_file}" ]]; then
                prompt_name=$(basename "${prompt_file}")
                target_path="${PI_PROMPTS_DIR}/${prompt_name}"

                if [[ -L "${target_path}" ]] || [[ -f "${target_path}" ]]; then
                    rm -f "${target_path}"
                fi

                if [[ "${MODE}" == "symlink" ]]; then
                    ln -s "${prompt_file}" "${target_path}"
                    echo -e "  ${GREEN}✓${NC} Linked prompt template: ${prompt_name}"
                else
                    cp "${prompt_file}" "${target_path}"
                    echo -e "  ${GREEN}✓${NC} Copied prompt template: ${prompt_name}"
                fi
            fi
        done
        echo -e "  Prompt templates location: ${PI_PROMPTS_DIR}"
    fi

    if [[ "${INSTALL_INSTRUCTIONS}" == true ]]; then
        install_instruction_file "${AGENTS_SOURCE}" "${PI_AGENT_FILE}" "global instructions"
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
        if [[ "${PROMPTS_ONLY}" == true ]]; then
            install_to_pi
        else
            install_to_claude
            install_to_codex
            install_to_pi
        fi
        ;;
esac

echo -e "${GREEN}=== Installation Complete ===${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"

if { [[ "${TARGET}" == "claude" ]] || [[ "${TARGET}" == "all" ]]; } && { [[ "${INSTALL_SKILLS}" == true ]] || [[ "${INSTALL_INSTRUCTIONS}" == true ]]; }; then
    echo -e "  ${YELLOW}Claude Code:${NC}"
    if [[ "${INSTALL_SKILLS}" == true ]]; then
        echo -e "    Restart Claude Code to load the skills"
        echo -e "    Use /help to see available skills"
    fi
    if [[ "${INSTALL_INSTRUCTIONS}" == true ]]; then
        echo -e "    Global instructions installed at ${CLAUDE_AGENT_FILE}"
    fi
    echo ""
fi

if { [[ "${TARGET}" == "codex" ]] || [[ "${TARGET}" == "all" ]]; } && { [[ "${INSTALL_SKILLS}" == true ]] || [[ "${INSTALL_INSTRUCTIONS}" == true ]]; }; then
    echo -e "  ${YELLOW}Codex:${NC}"
    if [[ "${INSTALL_SKILLS}" == true ]]; then
        echo -e "    Skills are ready to use in your next session"
    fi
    if [[ "${INSTALL_INSTRUCTIONS}" == true ]]; then
        echo -e "    Global instructions installed at ${CODEX_AGENT_FILE}"
    fi
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
    if [[ "${INSTALL_PROMPTS}" == true ]]; then
        echo -e "    Prompt templates are ready to use in your next session"
        echo -e "    Type /dummy to test the dummy prompt template"
    fi
    if [[ "${INSTALL_INSTRUCTIONS}" == true ]]; then
        echo -e "    Global instructions installed at ${PI_AGENT_FILE}"
    fi
    echo ""
fi

if [[ "${MODE}" == "symlink" ]]; then
    echo -e "${BLUE}Note:${NC} Installed files are symlinked - changes to source files will be reflected immediately"
else
    echo -e "${BLUE}Note:${NC} Installed files are copied - run this script again to update"
fi
