#!/bin/zsh

# Bootstrap a development environment for Matt Casper
# usage: ./bootstrap.zsh
#
# Other steps:
# Install iterm3
# Install 1password
# Create ssh key for GitHub
# Add ssh key password to keychain
# Setup sshconfig
# Install iterm color scheme
# Remap left fn -> control
# Remap caps lock -> control
# Reduce the size of the dock
# Turn off sound effects
# Add fingerprints
# Remove text shortcuts
# Turn off smart quotes
# In iterm2, set left option as Esc+

set -eo pipefail

# "${VAR-}" takes the value of the variable, or empty string if it doesn't exist
if [ -n "${TMUX-}" ]; then
  echo "I can't be run from inside a tmux session, please exit the session and run me in a bare terminal."
  exit 1
fi

if [[ $(pwd) != "$HOME/dotfiles" ]]; then
  echo "Dotfiles must be located at $HOME/dotfiles, I won't work from anywhere else."
  exit 1
fi

# Setup code directory
mkdir -p ~/code/home
mkdir -p ~/code/work

# Install essentials when necessary
if [[ $(/usr/bin/gcc 2>&1) =~ "no developer tools were found" ]] || [[ ! -x /usr/bin/gcc ]]; then
  echo "Installing Xcode"
  xcode-select --install
fi

sudo xcodebuild -license accept

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

# Git setup
mkdir -p "$HOME/.git_template/hooks"
cp git/ctags "$HOME/.git_template/hooks/ctags"
cp git/ctags_hook "$HOME/.git_template/hooks/post-commit"
cp git/ctags_hook "$HOME/.git_template/hooks/post-merge"
cp git/ctags_hook "$HOME/.git_template/hooks/post-checkout"
cp git/gitignore_global "$HOME/.gitignore_global"

# tern
npm install -g tern

# Dotfiles
rcup -f -d "$HOME/dotfiles/files" -v
. "$HOME/.zshrc"

SERVICES=("postgresql" "elasticsearch" "memcached" "redis" "consul")
for service in "${SERVICES[@]}"; do brew services start "$service"; done

# Set default shell
if ! [ "$SHELL" = "/bin/zsh" ]; then
  chsh -s /bin/zsh
fi

# Rehash so zsh can find all its commands
rehash

# Iterm Colors
if [[ ! -e "$HOME/code/iterm_colors" ]]; then
  mkdir -p "$HOME/code/iterm_colors"
  wget https://github.com/mbadolato/iTerm2-Color-Schemes/raw/master/schemes/PencilDark.itermcolors -O "$HOME/code/iterm_colors/PencilDark.itermcolors"
  wget https://github.com/mbadolato/iTerm2-Color-Schemes/raw/master/schemes/PencilLight.itermcolors -O "$HOME/code/iterm_colors/PencilLight.itermcolors"
fi

echo "Follow instructions for setting up profile colors: https://github.com/mbadolato/iTerm2-Color-Schemes#installation-instructions"

# Setup neovim
mkdir -p $HOME/.config
ln -sf $HOME/dotfiles/files/config/nvim $HOME/.config

# Install vim-plug
if ! [ -f "$HOME/.local/share/nvim/site/autoload/plug.vim" ]; then
  curl -fLo "$HOME/.local/share/nvim/site/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  nvim +PlugInstall +qall
else
  nvim +PlugUpdate +qall
fi

## Language specific installations

# Elixir - kiex (version manager)
if ! type kiex > /dev/null 2>&1; then
  curl -sSL https://raw.githubusercontent.com/taylor/kiex/master/install | bash -s
  . "$HOME/.zshrc"
fi

latest_elixir=$(kiex list known | tail -n 1 | xargs)

if ! [[ -n $(kiex list | grep "$latest_elixir") ]]; then
  kiex install "$latest_elixir"
fi

kiex use "$latest_elixir"
kiex default "$latest_elixir"
mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez --force

# Ruby - rbenv (version manager)
latest_ruby=$(rbenv install --list | grep -E '^\s+[0-9]\.[0-9]\.[0-9]$' | tail -n 1 | xargs)

if ! rbenv versions | grep -q "$latest_ruby"; then
  rbenv install "$latest_ruby"
  eval "$(rbenv init -)"
  gem install bundler
fi
rbenv global "$latest_ruby"

# Rust
curl https://sh.rustup.rs -sSf | bash -s -- -y
source $HOME/.cargo/env
rustup update
rustup component add rust-src
rustup default nightly
rustup component add rust-src

if ! [[ -n $(cargo install --list | grep ripgrep) ]]; then
  cargo install ripgrep
fi

if ! [[ -n $(cargo install --list | grep racer) ]]; then
  cargo install racer
fi

# Python
if [[ ! -e /usr/local/bin/python ]]; then
  ln -sfn /usr/bin/python /usr/local/bin/python
fi

pip2 install neovim --upgrade
pip3 install neovim --upgrade

# Google Cloud SDK
wget -O /Users/mattcasper/google-cloud-sdk.tar.gz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-138.0.0-darwin-x86_64.tar.gz
tar -xzf /Users/mattcasper/google-cloud-sdk.tar.gz -f /Users/mattcasper/google-cloud-sdk
rm -rf /Users/mattcasper/google-cloud-sdk.tar.gz
