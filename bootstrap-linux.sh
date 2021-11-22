#!/bin/bash

# Bootstrap a linux development environment for Matt Casper
# usage: bash bootstrap-linux.sh

set -eou pipefail

progress() {
    echo "===> ${1}"
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

progress "Installing common packages"
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt update -y
sudo apt install -y \
    git \
    neovim \
    nodejs \
    rcm \
    ripgrep \
    tmux \
    zsh

progress "Upgrading packages"
sudo apt upgrade -y

progress "Creating code directory"
mkdir -p ~/code

progress "Configuring git"
mkdir -p "$HOME/.git_template/hooks"
cp git/ctags "$HOME/.git_template/hooks/ctags"
cp git/ctags_hook "$HOME/.git_template/hooks/post-commit"
cp git/ctags_hook "$HOME/.git_template/hooks/post-merge"
cp git/ctags_hook "$HOME/.git_template/hooks/post-checkout"
cp git/gitignore_global "$HOME/.gitignore_global"

progress "Symlinking dotfiles"
rcup -f -d "$HOME/dotfiles/files" -v

progress "Setting shell to zsh"
if ! [ "$SHELL" = "/bin/zsh" ]; then
  chsh -s /usr/bin/zsh
fi

progress "Setting up neovim"
mkdir -p $HOME/.config
pip3 install neovim --upgrade

progress "Installing vim-plug"
if ! [ -f "$HOME/.local/share/nvim/site/autoload/plug.vim" ]; then
  curl -fLo "$HOME/.local/share/nvim/site/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  nvim +PlugInstall +qall
else
  nvim +PlugUpdate +qall
fi

progress "Installing asdf"
git clone git@github.com:asdf-vm/asdf $HOME/.asdf

echo "All done! Restart the machine to pick up the new default shell"
