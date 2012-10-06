# padde's oh-my-zsh theme

ZSH_THEME_GIT_PROMPT_SHA_BEFORE="%{$fg[black]%}|%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$fg[black]%}]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[black]%}[git:%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}●"
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_HG_PROMPT_REV_BEFORE="%{$fg[black]%}|%{$fg[yellow]%}"
ZSH_THEME_HG_PROMPT_REV_AFTER=":"
ZSH_THEME_HG_PROMPT_SHA_BEFORE=""
ZSH_THEME_HG_PROMPT_SHA_AFTER="%{$fg[black]%}]%{$reset_color%}"
ZSH_THEME_HG_PROMPT_PREFIX="%{$fg[black]%}[hg:%{$fg[green]%}"
ZSH_THEME_HG_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_HG_PROMPT_DIRTY="%{$fg[red]%}●"
ZSH_THEME_HG_PROMPT_CLEAN=""

ZSH_THEME_EXIT_CODE="%(?..%{$fg[red]%}↯%?%{$reset_color%})"

if [ $UID -eq 0 ]; then
  NCOLOR="$bg[red]$fg_bold[white]";
else 
  NCOLOR="$fg[blue]";
fi

PROMPT="%{$PROMPT_BG%}%{$fg[black]%}%T %{$NCOLOR%}%n%{$reset_color$fg[black]%}@%{$fg[blue]%}%m%{$fg[black]%}:%{$fg[red]%}%2c%{$fg[black]%}$ %{$reset_color%}"
RPROMPT=$'$(git_prompt_info)$(git_prompt_short_sha)$(hg_prompt_info)$(hg_prompt_rev)$(hg_prompt_short_sha)${EXIT_CODE}'

function accept-line-and-enable-warning {
  if [ -z "$BUFFER" ]; then
    PROMPT_BG=
  else
    EXIT_CODE=$ZSH_THEME_EXIT_CODE
    PROMPT_BG="%{$bg[red]%}"
  fi
  
  zle accept-line
}

zle -N accept-line-and-enable-warning
bindkey '^M' accept-line-and-enable-warning

