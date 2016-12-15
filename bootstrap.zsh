#!/bin/zsh

# Bootstrap a development environment for Matt Casper
# usage: ./bootstrap.zsh

set -eo pipefail

# "${VAR-}" takes the value of the variable, or empty string if it doesn't exist
if [ -n "${TMUX-}" ]; then
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

# Git setup
mkdir -p "$HOME/.git_template/hooks"
cp git/ctags "$HOME/.git_template/hooks/ctags"
cp git/ctags_hook "$HOME/.git_template/hooks/post-commit"
cp git/ctags_hook "$HOME/.git_template/hooks/post-merge"
cp git/ctags_hook "$HOME/.git_template/hooks/post-checkout"

# Dotfiles
rcup -f -d "$HOME/code/dotfiles"
. "$HOME/.zshrc"

SERVICES=("postgresql" "elasticsearch" "memcached" "redis")
for service in "${SERVICES[@]}"; do brew services start "$service"; done

# Set default shell
if ! [ "$SHELL" = "/bin/zsh" ]; then
  chsh -s /bin/zsh
fi

# Rehash so zsh can find all its commands
rehash

# Install vim-plug
if ! [ -f "$HOME/.vim/autoload/plug.vim" ]; then
  curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  vim +PlugInstall +qall
else
  vim +PlugUpdate +qall
fi

## Cloning

git_clone ()
{
  ORG=${1-}
  REPO=${2-}
  DIR_PATH=${3-}

  if ! [ -n "$ORG" ]; then
    echo "git_clone() expects \$1 to be an org"
    exit 1
  fi

  if ! [ -n "$REPO" ]; then
    echo "git_clone() expects \$2 to be a repo"
    exit 1
  fi

  if ! [ -n "$DIR_PATH" ]; then
    echo "git_clone() expects \$3 to be a path"
    exit 1
  fi

  if ! [ -d "$DIR_PATH/$REPO" ]; then
    git clone "git@github.com:${ORG}/${REPO}" "$DIR_PATH/$REPO"
  else
    echo "$DIR_PATH/$REPO already exists, skipping"
  fi
}

procore_clone ()
{
  git_clone "procore" "$1" "$HOME/code/work"
}

upto_clone ()
{
  git_clone "upto" "$1" "$HOME/code/home/upto"
}

PROCORE_REPOS=("procore" "ios" "puppet" "mobile-shared")
for repo in $PROCORE_REPOS; do procore_clone "$repo"; done

UPTO_REPOS=("cocoamates-marketing" "leads-marketing" "contact-us" "scripts" "bach-bracket")
for repo in $UPTO_REPOS; do upto_clone "$repo"; done

UPTO_APPS=("log-rx" "conner" "room-tracker")
for repo in $UPTO_APPS; do upto_clone "${repo}-backend"; upto_clone "${repo}-ios"; done

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
  gem install bundler
fi
rbenv global "$latest_ruby"

# Rust
curl https://sh.rustup.rs -sSf | bash -s -- -y
rustup update

if ! [[ -n $(cargo install --list | grep ripgrep) ]]; then
  cargo install ripgrep
fi

# Google Cloud SDK
wget -O /Users/mattcasper/google-cloud-sdk.tar.gz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-138.0.0-darwin-x86_64.tar.gz
tar -xzf /Users/mattcasper/google-cloud-sdk.tar.gz -f /Users/mattcasper/google-cloud-sdk
rm -rf /Users/mattcasper/google-cloud-sdk.tar.gz
