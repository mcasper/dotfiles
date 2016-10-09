#!/bin/bash

# Bootstrap a development environment for Matt Casper
# usage: bash bootstrap.sh

# Setup code directory
mkdir -p ~/code/home

# Install essentials when necessary
if [[ $(/usr/bin/gcc 2>&1) =~ "no developer tools were found" ]] || [[ ! -x /usr/bin/gcc ]]; then
  echo "Installing Xcode"
  xcode-select --install
fi

# Download and install Homebrew
if [[ ! -x /usr/local/bin/brew ]]; then
  echo "Installing Homebrew"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew update
fi

TAPS=("caskroom/cask" "homebrew/boneyard" "homebrew/core" "homebrew/dupes" "homebrew/python" "homebrew/science" "homebrew/services" "homebrew/versions" "joshuaclayton/formulae" "neovim/neovim" "thoughtbot/formulae")
SERVICES=("postgresql" "elasticsearch" "memcached" "redis")
PACKAGES=("carthage" "git" "heroku" "ncdu" "openssh" "swiftlint" "v8" "tmux" "wget" "unused" "z" "zsh" "vim")

for tap in "${TAPS[@]}"; do brew tap $tap; done
for service in "${SERVICES[@]}"; do brew install $service; brew services start $service; done
for package in "${PACKAGES[@]}"; do brew install $package; done

## Language specific installations

# Elixir - kiex (version manager)
curl -sSL https://raw.githubusercontent.com/taylor/kiex/master/install | bash -s
latest_elixir=$(kiex list known | tail -n 1 | xargs)
kiex install $latest_elixir
kiex use $latest_elixir
kiex default $latest_elixir

# Ruby - rbenv (version manager)
brew install rbenv
brew install ruby-build
latest_ruby=$(rbenv install --list | grep -E '^\s+[0-9]\.[0-9]\.[0-9]$' | tail -n 1 | xargs)
rbenv install $latest_ruby
rbenv global $latest_ruby

# Elm
brew install elm

# Go
brew install go
