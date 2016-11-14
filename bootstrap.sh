#!/bin/bash

# Bootstrap a development environment for Matt Casper
# usage: bash bootstrap.sh

if [ -n "$TMUX" ]; then
  echo "I can't be run from inside a tmux session, please exit the session and run me in a bare terminal."
  exit 1
fi

# Setup code directory
mkdir -p ~/code/home/upto
mkdir -p ~/code/work

# Install essentials when necessary
if [[ $(/usr/bin/gcc 2>&1) =~ "no developer tools were found" ]] || [[ ! -x /usr/bin/gcc ]]; then
  echo "Installing Xcode"
  xcode-select --install
fi

# Download and install Homebrew
if [[ ! -x /usr/local/bin/brew ]]; then
  echo "Installing Homebrew"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Install homebrew bundle
echo "Updating brew, running 'brew bundle', and upgrading packages"
brew update
brew tap Homebrew/bundle
brew bundle --verbose
brew upgrade

# Dotfiles
rcup -f -d "$HOME/code/dotfiles"
source "$HOME/.zshrc"

SERVICES=("postgresql" "elasticsearch" "memcached" "redis")
for service in "${SERVICES[@]}"; do brew services start $service; done

# Set default shell
if ! [ "$SHELL" == "/bin/zsh" ]; then
  chsh -s /bin/zsh
fi

## Cloning

PROCORE_REPOS=("procore" "ios" "puppet" "mobile-shared")
for repo in "${PROCORE_REPOS[@]}"; do git clone "git@github.com:procore/${repo}" "$HOME/code/work/${repo}"; done

UPTO_REPOS=("cocoamates-marketing" "leads-marketing" "contact-us" "scripts" "bach-bracket")
for repo in "${UPTO_REPOS[@]}"; do git clone "git@github.com:upto/${repo}" "$HOME/code/home/upto/${repo}"; done

UPTO_APPS=("log-rx" "conner" "room-tracker")
for repo in "${UPTO_APPS[@]}"; do git clone "git@github.com:upto/${repo}-backend" "$HOME/code/home/upto/${repo}-backend"; git clone "git@github.com:upto/${repo}-ios" "$HOME/code/home/upto/${repo}-ios"; done

## Language specific installations

# Elixir - kiex (version manager)
curl -sSL https://raw.githubusercontent.com/taylor/kiex/master/install | bash -s
latest_elixir=$(kiex list known | tail -n 1 | xargs)
kiex install $latest_elixir
kiex use $latest_elixir
kiex default $latest_elixir
mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez --force

# Ruby - rbenv (version manager)
brew install rbenv
yes | brew install ruby-build
latest_ruby=$(rbenv install --list | grep -E '^\s+[0-9]\.[0-9]\.[0-9]$' | tail -n 1 | xargs)
rbenv install $latest_ruby
rbenv global $latest_ruby

# Elm
brew install elm

# Go
brew install go

# Rust
curl https://sh.rustup.rs -sSf | bash -s -- -y
rustup update
