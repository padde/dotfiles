export PATH=/usr/local/bin:$PATH

source ~/.dotfiles/zsh/antigen/antigen.zsh

antigen use oh-my-zsh

antigen bundle autojump
antigen bundle rbenv
antigen bundle bundler
antigen bundle osx
antigen bundle zsh-users/zsh-syntax-highlighting

# completion
autoload -U compinit
compinit

# use vim as editor
local VIM_BINARY=/bin/vim
if [[ -d /Applications/MacVim.app ]]; then
  VIM_BINARY='/Applications/MacVim.app/Contents/MacOS/Vim'
elif [[ -d ~/Applications/MacVim.app ]]; then
  VIM_BINARY='~/Applications/MacVim.app/Contents/MacOS/Vim'
fi
export VISUAL=$VIM_BINARY
export EDITOR=$VIM_BINARY
alias vim=$VIM_BINARY
alias vi=$VIM_BINARY

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
if which vimpager > /dev/null; then
  export PAGER=vimpager
elif which most > /dev/null; then
  export PAGER=most
fi

# update submodules
function update_dotfiles {
  cd ~/.dotfiles
  git pull origin master
  git submodule foreach git pull origin master
  cd -
}

# aliases
alias cl=clear
alias c=clear
alias guard-pdflatex='guard --guardfile ~/.dotfiles/guard/pdflatex-biber/Guardfile'
alias guard-xelatex='guard --guardfile ~/.dotfiles/guard/xelatex-biber/Guardfile'
alias lla='ll -a'
alias t='tmux'
alias g='git'
alias ga='git add'
alias gadd='git add'
alias gap='git add -p'
alias gaddp='git add -p'
alias gst='git st'
alias gstatus= 'git status'
alias gl='git l'
alias glog='git log'
alias gdf='git df'
alias gdfs='git dfs'
alias gdiff='git diff'
alias gci='git ci'
alias gcommit='git commit'
alias gco='git co'
alias gcop='git co -p'
alias gp='git pull'
alias gpu='git pull'
alias gpull='git pull'
alias gpush='git push'
alias gres='git reset'
alias greset='git reset'
alias gresp='git reset -p'
alias gresetp='git reset -p'
alias rmig='rake db:migrate'

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

# prompt
# export ZLE_RPROMPT_INDENT=0

__PROMPT_VCS_DELIMITER_COLOR="$fg_bold[black]"
__PROMPT_VCS_DIRTY_COLOR="$fg[red]"
__PROMPT_VCS_BRANCH_COLOR="$fg[green]"
__PROMPT_VCS_HASH_COLOR="$fg[yellow]"
__PROMPT_EXIT_CODE_STR="%(?..%{$fg[red]%}↯%?%{$reset_color%})"
__PROMPT_DELIMITER_COLOR="$fg_bold[black]"
__PROMPT_PWD_COLOR="$fg[red]"

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

function __git_hash {
  git log -1 --format="%h" 2>/dev/null || print '(none)'
}

function __git_prompt {
  if __find_git_root; then
    local dirty_str=''
    if __git_dirty; then
      dirty_str='●'
    fi

    print " "\
"%{$__PROMPT_VCS_DIRTY_COLOR%}${dirty_str}%{$reset_color%}"\
"%{$__PROMPT_VCS_DELIMITER_COLOR%}git:%{$reset_color%}"\
"%{$__PROMPT_VCS_BRANCH_COLOR%}$(__git_branch)%{$reset_color%}"\
"%{$__PROMPT_VCS_DELIMITER_COLOR%}@%{$reset_color%}"\
"%{$__PROMPT_VCS_HASH_COLOR%}$(__git_hash)%{$reset_color%}"
  fi
}

function __find_hg_root {
  local dir=`pwd`
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

    print " "\
"%{$__PROMPT_VCS_DIRTY_COLOR%}${dirty_str}%{$reset_color%}"\
"%{$__PROMPT_VCS_DELIMITER_COLOR%}hg:%{$reset_color%}"\
"%{$__PROMPT_VCS_BRANCH_COLOR%}$(__hg_branch)%{$reset_color%}"\
"%{$__PROMPT_VCS_DELIMITER_COLOR%}@%{$reset_color%}"\
"%{$__PROMPT_VCS_HASH_COLOR%}$(__hg_hash)%{$reset_color%}"
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

PROMPT='${__PROMPT_BG}'\
"%{$__PROMPT_PWD_COLOR%}"'$(__abbrev_pwd)'"%{$reset_color%}"\
"%{$__PROMPT_DELIMITER_COLOR%}$%{$reset_color%} "

RPROMPT='${__PROMPT_EXIT_CODE}$(__git_prompt)$(__hg_prompt)'

# Rbenv
PATH=~/.rbenv/shims:$PATH

# node
PATH=$PATH:/usr/local/share/npm/bin
