export PS1="\[\e[32m\]\w\[\e[m\]> "
#export DISPLAY=:0

export EDITOR="atom --wait"
export PATH=/home/torsten/bin:$PATH

# User specific environment and startup programs
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

alias ll="ls -l --color"
alias ci="git commit -m "
alias ad="git add "
alias st="git status "
alias pu="git push "
alias di="git diff "
alias m="atom"
alias pi="ssh -p 2222 -l pi localhost"
alias zero="ssh pi@zero.local"
alias deploy="git push heroku master"

alias s="rm log/*;bundle exec rails server"
alias c="bundle exec rails console"
alias g="bundle exec guard"
alias be="bundle exec "
alias ber="bundle exec rspec"
alias bep="bundle exec passenger start"
alias f="find . -name "

alias test_all="NCPU=16 ruby test/test_all.rb"

alias web="ssh feenix@192.168.129.10"
alias web_root="ssh root@192.168.129.10"
