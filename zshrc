export PATH=/usr/local/bin:$PATH

source ~/.dotfiles/zsh/antigen.zsh

antigen use oh-my-zsh

antigen bundle autojump
antigen bundle rbenv
antigen bundle bundler
antigen bundle osx
antigen bundle docker
antigen bundle zsh-users/zsh-syntax-highlighting

# completion
autoload -U compinit
compinit

# use vim as editor
export VISUAL=vim
export EDITOR=vim

# vi mode
bindkey -v
bindkey "^F" vi-cmd-mode
# bindkey jj vi-cmd-mode
bindkey "^?" backward-delete-char

# history search
bindkey '\C-p' history-beginning-search-backward
bindkey '\C-n' history-beginning-search-forward
bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward 

# history
setopt histignoredups
export HISTSIZE=10000

# autocorrect
setopt CORRECT

# extended globbing
setopt EXTENDED_GLOB

# do not set title automatically
DISABLE_AUTO_TITLE=true

# Use most as pager, if available
if which most > /dev/null; then
  export PAGER=most
fi

# utf-8 ftw!
export LC_ALL=en_US.UTF-8

# update submodules
function update_dotfiles {
  cd ~/.dotfiles
  git pull origin master
  git submodule foreach git pull origin master
  cd -
}

# aliases
alias cl=clear
alias g='git'
alias ga='git add'
alias gci='git ci'
alias gco='git co'
alias gdf='git df'
alias gdfs='git df --staged'
alias gl='git l'
alias gst='git st'
alias lla='ll -a'
alias rmig='rake db:migrate'
alias rback='rake db:rollback'
alias ts="awk '{print strftime(\"[%Y-%m-%d %H:%M:%S]\"), \$0; fflush();}'"

# colorize listings (especially in `tree`)
export LS_COLORS="no=00:di=34:ln=35:so=33"
export LS_COLORS="ex=37;41:$LS_COLORS"
export LS_COLORS="*.zip=36:*.rar=36:*.tar=36:*.gz=36:*.tar.gz=36:*.7z=36:$LS_COLORS"
export LS_COLORS="*.c=32:*.cc=32:*.cpp=32:*.m=32:*.rb=32:*.pl=32:*.php=32:*.java=32:$LS_COLORS"
export LS_COLORS="*.h=33:*.hpp=33:$LS_COLORS"
export LS_COLORS="*.o=30:*.d=30:$LS_COLORS"
export LS_COLORS="*Makefile=35:*.mk=35:*Rakefile=35:$LS_COLORS"

# use 256 colors (fixes tmux colors)
export TERM="xterm-256color"

# highlight grep results
export GREP_COLOR="1;31"

# case insensitive matches in autojump
export AUTOJUMP_IGNORE_CASE=1

# helper functions
function truncate_string {
  max=$1
  ellipsis=$(if [ ! -z $2 ]; then echo $2; else echo "…"; fi)
  read string
  len=$(echo "${#string}")
  if [ $len -gt $max ]; then
    print $string[1,$(($max - 1))]$ellipsis
  else
    print $string
  fi
}

# aixterm color escape sequences: bright but *not* bold, work also when the
# option "Draw bold text in bright colors" in iTerm2 is unchecked.
typeset -A fg_bright
fg_bright[black]="[90m"
fg_bright[red]="[91m"
fg_bright[green]="[92m"
fg_bright[yellow]="[93m"
fg_bright[blue]="[94m"
fg_bright[magenta]="[95m"
fg_bright[cyan]="[96m"
fg_bright[white]="[97m"

# prompt
__PROMPT_VCS_DELIMITER_COLOR="$fg_bright[black]"
__PROMPT_VCS_DIRTY_COLOR="$fg[red]"
__PROMPT_VCS_BRANCH_COLOR="$fg[green]"
__PROMPT_VCS_HASH_COLOR="$fg[yellow]"
__PROMPT_EXIT_CODE_STR="%(?..%{$fg[red]%}↯%?%{$reset_color%} )"
__PROMPT_DELIMITER_COLOR="$fg_bright[black]"
__PROMPT_TIME_COLOR="$fg_bright[black]"
__PROMPT_PWD_COLOR="$fg[blue]"

function __accept_line_and_enable_warning {
  __PROMPT_EXIT_CODE=$__PROMPT_EXIT_CODE_STR
  zle accept-line
}
zle -N __accept_line_and_enable_warning
bindkey '^M' __accept_line_and_enable_warning

function __find_git_root {
  git rev-parse --show-toplevel > /dev/null 2>&1
}

function __git_dirty {
  test -n "`git status --porcelain`"
}

function __git_branch {
  git rev-parse --abbrev-ref HEAD 2>/dev/null
}

function __git_abbrev_branch {
  __git_branch | truncate_string 20 "⋯"
}

function __git_hash {
  git log -1 --format="%h" 2>/dev/null || print '(none)'
}

function __git_prompt {
  if __find_git_root; then
    local dirty_str=''
    if __git_dirty; then
      dirty_str='●'
    fi

    print "%{$__PROMPT_VCS_DIRTY_COLOR%}${dirty_str}%{$reset_color%}"\
"%{$__PROMPT_VCS_BRANCH_COLOR%}$(__git_abbrev_branch)%{$reset_color%}"\
"%{$__PROMPT_VCS_DELIMITER_COLOR%}@%{$reset_color%}"\
"%{$__PROMPT_VCS_HASH_COLOR%}$(__git_hash)%{$reset_color%} "
  fi
}

function __find_hg_root {
  local dir="$(pwd)"
  HG_ROOT=''

  while [ $dir != "/" ]; do
    if [ -d "$dir/.hg" ]; then
      HG_ROOT="$dir/.hg"
      return 0
    fi
    dir=`dirname $dir`
  done

  return 1
}

function __hg_dirty {
  test -n "`hg status --cwd $HG_ROOT`"
}

function __hg_branch {
  cat "$HG_ROOT/branch" 2>/dev/null || hg branch
}

function __hg_hash {
  if [ -f "$HG_ROOT/dirstate" ]; then
    hexdump -n 4 -e '2/1 "%02x"' "$HG_ROOT/dirstate" | cut -c-7
  else
    print '(none)'
  fi
} 

function __hg_prompt {
  if __find_hg_root; then
    local dirty_str=''
    if __hg_dirty; then
      dirty_str='●'
    fi

    print "%{$__PROMPT_VCS_DIRTY_COLOR%}${dirty_str}%{$reset_color%}"\
"%{$__PROMPT_VCS_BRANCH_COLOR%}$(__hg_branch)%{$reset_color%}"\
"%{$__PROMPT_VCS_DELIMITER_COLOR%}@%{$reset_color%}"\
"%{$__PROMPT_VCS_HASH_COLOR%}$(__hg_hash)%{$reset_color%} "
  fi
}

function __abbrev_pwd {
  local pwd="${PWD/#$HOME/~}"

  if [[ "$pwd" == (#m)[/~] ]]; then
    print $MATCH
  else
    print "${${${(@j:/:M)${(@s:/:)pwd}##.#?}:h}%/}/${pwd:t}"
  fi
}

PROMPT=\
"%{$__PROMPT_TIME_COLOR%}"'%D{%H:%M} '\
'${__PROMPT_EXIT_CODE}$(__git_prompt)$(__hg_prompt)'\
"%{$__PROMPT_DELIMITER_COLOR%}"'${__PROMPT_BG}'\
"%{$__PROMPT_PWD_COLOR%}"'$(__abbrev_pwd)'"%{$reset_color%}
%{$__PROMPT_DELIMITER_COLOR%}%#%{$reset_color%} "


# tmux title
if [ -n $TMUX ]; then
  function set_tmux_title {
    tmux rename-window "$(basename $(__abbrev_pwd))"
  }

  chpwd() {
    set_tmux_title
  }

  set_tmux_title
fi

# node
PATH=$PATH:/usr/local/share/npm/bin

# Postgres.app
export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/9.3/bin

# OMG Java
export JAVA_HOME=$(/usr/libexec/java_home)

# Ramp up Vagrant
export VM_RAM=4096
export VM_CPUS=4

# added by travis gem
[ -f /Users/patrickoscity/.travis/travis.sh ] && source /Users/patrickoscity/.travis/travis.sh

# local configuration
if [ -f ~/.zshrc.local ]; then
  source ~/.zshrc.local
fi

# Docker Mac
if which docker-machine > /dev/null; then
  function start-docker-machine {
    docker-machine start default
    eval "$(docker-machine env default)"
  }
fi
