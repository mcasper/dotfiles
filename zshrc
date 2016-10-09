## Aliases ##

# General
alias la="ls -al"
alias ln="ln -v"
alias mkdir="mkdir -p"
alias grep="grep --color=auto"
alias cp="cp -r"
alias ..="cd ../"
alias ...="cd ../.."
alias ....="cd ../../.."
alias ltree="tree -L 1"

# tmux
alias tma="tmux att -t"
alias tmls="tmux ls"
alias t2="tmux -2"

# Bundler
alias b="bundle"
alias be="bundle exec"

# Rails
alias migrate="bin/rake db:migrate"
alias rake="bin/rake"

# Elixir
alias imix="iex -S mix"
alias server="iex -S mix phoenix.server"

# Git
alias g="git"
alias co="git checkout"
alias gcm="git checkout master"
alias gs="git status"
alias gpush="git push"
alias gpull="git pull"
alias gpoh="git push origin HEAD"
alias gsu="git submodule update"
alias gap="git add -p"
alias grm="git pull --rebase origin master"
alias gupdate="git pull && git-clean -y"

# Docker
# alias dockersource="eval $(docker-machine env default)"

## User configuration ##

# History
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE=~/.history
setopt SHARE_HISTORY

# Path VARs
export GOPATH="$HOME/code/gocode:/code/work/pgnetdetective"
export PATH="/usr/local/bin:/usr/bin:/usr/local/rbenv/bin:/usr/local/rbenv/shims:/usr/local/bin:$HOME/.multirust/toolchains/nightly/cargo/bin:$PATH"
export PATH="/Users/mattcasper/.multirust/toolchains/stable/cargo/bin:$PATH"
export PATH="/Users/mattcasper/.multirust/toolchains/beta/cargo/bin:$PATH"
export PATH="/Users/mattcasper/.multirust/toolchains/nightly/cargo/bin:$PATH"
export PATH="$GOPATH/bin:$PATH"

# Start rbenv
eval "$(rbenv init -)"

# Path Settings
# - MATTCASPER.local work/go/action_tracker_queue (master) $
setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' stagedstr 'M '
zstyle ':vcs_info:*' unstagedstr 'M '
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' actionformats '%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats \
  '%F{5}(%F{2}%b%F{5}) %F{2}%c%F{3}%u%f'
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
zstyle ':vcs_info:*' enable git

precmd () { vcs_info }
PROMPT='%F{5} - %F{2}%M%F{5} %F{3}%3~ ${vcs_info_msg_0_}%f$ '

# Source FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Source and load Git completion
autoload -Uz compinit && compinit

# Z
source `brew --prefix`/etc/profile.d/z.sh

# Cargo
source /Users/mattcasper/.cargo/env

# Kiex
[ -f "$HOME/.kiex/scripts/kiex" ] && source "$HOME/.kiex/scripts/kiex"

# added by travis gem
[ -f /Users/mattcasper/.travis/travis.sh ] && source /Users/mattcasper/.travis/travis.sh

fpath+=~/.zfunc
