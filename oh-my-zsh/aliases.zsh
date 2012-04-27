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