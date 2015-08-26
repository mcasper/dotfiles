# Aliases

# Unix
alias la="ls -al"
alias ln="ln -v"
alias mkdir="mkdir -p"
alias grep="grep --color=auto"
alias cp="cp -r"
alias ...="../.."
alias ....="../../.."
alias l="ls -lah"
alias ll="ls -lh"
alias lh="ls -Alh"

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
eval "$(hub alias -s)"
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

# chrome_circle() {
#   CIRCLE_URL = eval("g ci-status -v") | awk '{ print $2 }'
#   echo $CIRCLE_URL
#   open -a "Google Chrome" $CIRCLE_URL
# }
# alias circle="chrome_circle()"

# User configuration

# export tMANPATH="/usr/local/man:$MANPATH"
export PATH="/bin/lein:Users/mattcasper/.rbenv/shims:/Users/mattcasper/.rbenv/bin:/usr/local/pgsql/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/opt/ruby/bin/:$PATH"
export RBENV_ROOT="/Users/mattcasper/.rbenv"

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

eval "$(rbenv init -)"

setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' stagedstr 'M'
zstyle ':vcs_info:*' unstagedstr 'M'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' actionformats '%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats \
  '%F{5}[%F{2}%b%F{5}] %F{2}%c%F{3}%u%f'
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
zstyle ':vcs_info:*' enable git
+vi-git-untracked() {
if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
  git status --porcelain | grep '??' &> /dev/null ; then
hook_com[unstaged]+='%F{1}??%f'
  fi
}

precmd () { vcs_info }
PROMPT='%F{5}[%F{2}%n%F{5}] %F{3}%3~ ${vcs_info_msg_0_} %f%# '
