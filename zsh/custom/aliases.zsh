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
