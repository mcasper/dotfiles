# Aliases

# Linux
alias la="ls -al"
alias ln="ln -v"
alias mkdir="mkdir -p"
alias grep="grep --color=auto"
alias cp="cp -r"
alias ..="cd ../"
alias ...="cd ../.."
alias ....="cd ../../.."
alias ltree="tree -L 1"

# Servers
alias server_console="sudo -i -u www-data bash -c 'cd /data/procore/current && bundle exec rails c'"

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
alias s="puma -b tcp://0.0.0.0 -p 3000"

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

# User configuration

export GOPATH=$HOME/code/work/go
export PATH="/usr/local/rbenv/bin:/usr/local/rbenv/shims:/usr/local/bin:$PATH"
export PATH="$GOPATH/bin:$PATH"

eval "$(rbenv init -)"

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
