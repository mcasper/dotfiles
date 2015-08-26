export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="edvardm"

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

# /Aliases

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# expor tMANPATH="/usr/local/man:$MANPATH"
export PATH="/bin/lein:Users/mattcasper/.rbenv/shims:/Users/mattcasper/.rbenv/bin:/usr/local/pgsql/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/opt/ruby/bin/:$PATH"
export RBENV_ROOT="/Users/mattcasper/.rbenv"
export SALTPATH=/usr/local/Cellar/salt/2.4/data

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

eval "$(rbenv init -)"
