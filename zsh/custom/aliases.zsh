alias bye='exit'
alias lla='ll -a'
alias dotfiles="mate ~/.dotfiles"
alias cdd="cd ~/.dotfiles"

# textmate
function mate_arg {
	if test -z "$1"
	then
	  mate .
	else
	  mate $1
	fi
}
alias m='mate_arg'

# textmate 2
function mate2_arg {
	if test -z "$1"
	then
	  mate2 .
	else
	  mate2 $1
	fi
}
alias m2='mate2_arg'

# update dotfiles etc
function update_dotfiles {
    cd ~/.dotfiles
    git pull origin master
    git submodule foreach git pull origin master
    cd -
}

alias guard-pdflatex='guard --guardfile ~/.dotfiles/guard/pdflatex-biber/Guardfile'
alias guard-xelatex='guard --guardfile ~/.dotfiles/guard/xelatex-biber/Guardfile'

# use manservant for manpages if available
manservant () {
  open "http://man.dev/$1"
}
alias mans=manservant

# if [ -d "/Users/$(echo $USER)/.pow/man" ]; then
#   alias man_=man
#   alias man=manservant
# fi

alias cl=clear
alias c=clear

alias todo='grep -rnE "^.*(([tT][oO][dD][oO])|([fF][iI][xX][mM][eE])|([xX]{3})).*$" --exclude=".*" --exclude-dir=".*" -C3'

# shortcut for Postgres' pg_ctl
alias pg='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log'


alias a=ant
alias cdc='cd ~/Code/'

# bitbucket stuff
alias hg-remote-url='cat .hg/hgrc hgrc.default | grep "^default = .*ssh://" | sed "s/default \= .*@/https:\/\//" | tail -n1'

alias bitbucket='open "`hg-remote-url`"'
alias bb='bitbucket'

alias bitbucket-source='open "`hg-remote-url`/src"'
alias bitbucket-src='bitbucket-source'
alias bbs='bitbucket-source'

alias bitbucket-commits='open "`hg-remote-url`/commits"'
alias bitbucket-com='bitbucket-commits'
alias bbc='bitbucket-commits'

bitbucket-blame(){ open "`hg-remote-url`/annotate/`hg log -l1 --template '{node}'`/$1" }
alias bbb='bitbucket-blame'

alias tx='tmux'
alias txn='tmux new -s'
alias txa='tmux attach -t'
alias txs='tmux switch -t'
alias txl='tmux list-sessions'
alias txd='tmux detach'
