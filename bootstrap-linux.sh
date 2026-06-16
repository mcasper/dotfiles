#!/bin/bash

# Bootstrap a linux development environment for Matt Casper
# usage: bash bootstrap-linux.sh

set -euo pipefail

progress() {
    echo "===> ${1}"
}

warn() {
    echo "WARN: ${1}" >&2
}

# "${VAR-}" takes the value of the variable, or empty string if it doesn't exist
if [ -n "${TMUX-}" ]; then
  echo "I can't be run from inside a tmux session, please exit the session and run me in a bare terminal."
  exit 1
fi

if [[ $(pwd) != "$HOME/dotfiles" ]]; then
  echo "Dotfiles must be located at $HOME/dotfiles, I won't work from anywhere else."
  exit 1
fi

if ! command -v apt >/dev/null 2>&1; then
  echo "This bootstrap currently expects a Debian/Ubuntu host with apt."
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

progress "Installing common packages"
sudo apt update -y
sudo apt install -y \
    build-essential \
    ca-certificates \
    curl \
    fzf \
    git \
    keychain \
    neovim \
    python3-pynvim \
    rcm \
    ripgrep \
    tmux \
    tree \
    universal-ctags \
    zsh

progress "Upgrading packages"
sudo apt upgrade -y

progress "Installing current Neovim"
# Ubuntu 24.04 ships Neovim 0.9.x, but this config's plugins require 0.10+.
# Install the official release in ~/.local so it takes precedence without
# replacing the distro package.
mkdir -p "$HOME/.local/bin"
if ! command -v nvim >/dev/null 2>&1 || ! nvim --version | head -1 | grep -Eq 'NVIM v0\.(1[0-9]|[2-9][0-9])|NVIM v[1-9]'; then
  tmpdir="$(mktemp -d)"
  trap 'rm -rf "$tmpdir"' EXIT
  curl -fsSL -o "$tmpdir/nvim.tar.gz" https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
  tar -xzf "$tmpdir/nvim.tar.gz" -C "$tmpdir"
  rm -rf "$HOME/.local/nvim-linux-x86_64"
  mv "$tmpdir/nvim-linux-x86_64" "$HOME/.local/nvim-linux-x86_64"
  ln -sfn "$HOME/.local/nvim-linux-x86_64/bin/nvim" "$HOME/.local/bin/nvim"
  export PATH="$HOME/.local/bin:$PATH"
fi

progress "Creating code directory"
mkdir -p "$HOME/code"

progress "Configuring git"
mkdir -p "$HOME/.git_template/hooks"
cp git/ctags "$HOME/.git_template/hooks/ctags"
cp git/ctags_hook "$HOME/.git_template/hooks/post-commit"
cp git/ctags_hook "$HOME/.git_template/hooks/post-merge"
cp git/ctags_hook "$HOME/.git_template/hooks/post-checkout"
cp git/gitignore_global "$HOME/.gitignore_global"

if [ -f "$HOME/.ssh/id_ed25519.pub" ]; then
  signing_key="$HOME/.ssh/id_ed25519.pub"
  gpgsign="true"
else
  signing_key=""
  gpgsign="false"
fi

cat > "$HOME/.gitconfig.local" <<GITCONFIG
[credential]
  helper =
  helper = cache --timeout=21600
[commit]
  gpgsign = ${gpgsign}
GITCONFIG

if [ -n "$signing_key" ]; then
  cat >> "$HOME/.gitconfig.local" <<GITCONFIG
[user]
  signingkey = ${signing_key}
GITCONFIG
fi

progress "Symlinking dotfiles"
if [ -e "$HOME/.bashrc" ] && [ ! -L "$HOME/.bashrc" ] && [ ! -e "$HOME/.bashrc.pre-dotfiles" ]; then
  cp "$HOME/.bashrc" "$HOME/.bashrc.pre-dotfiles"
fi
rcup -f -d "$HOME/dotfiles/files" -v

progress "Setting shell to zsh"
zsh_path="$(command -v zsh)"
if [ "${SHELL-}" != "$zsh_path" ]; then
  chsh -s "$zsh_path" || sudo chsh -s "$zsh_path" "$(id -un)" || warn "Could not change login shell automatically; run: chsh -s $zsh_path"
fi

progress "Setting up mise"
if ! command -v mise >/dev/null 2>&1; then
  curl https://mise.run | sh
  export PATH="$HOME/.local/bin:$PATH"
fi
if command -v mise >/dev/null 2>&1; then
  mise trust "$HOME/dotfiles/mise.toml" || true
  mise install
else
  warn "mise is still not on PATH; skipping mise install"
fi

progress "Setting up neovim plugins"
mkdir -p "$HOME/.config"
if command -v nvim >/dev/null 2>&1; then
  nvim --headless "+Lazy! sync" +qa || warn "Neovim plugin sync failed; open nvim later to retry"
fi

echo "All done! Restart the terminal (or the machine) to pick up the new default shell."
