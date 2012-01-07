# padde's oh-my-zsh theme

ZSH_THEME_GIT_PROMPT_SHA_BEFORE="%{$fg[black]%}|%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$fg[black]%}]%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[black]%}[%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}●"
ZSH_THEME_GIT_PROMPT_CLEAN=""

if [ $UID -eq 0 ]; then
	NCOLOR="$bg[red]$fg_bold[white]";
else 
	NCOLOR="$fg[blue]";
fi

PROMPT="%{$fg[black]%}%T %{$NCOLOR%}%n%{$reset_color$fg[black]%}@%{$fg[blue]%}%m%{$fg[black]%}:%{$fg[red]%}%2c%{$fg[black]%}$ %{$reset_color%}"
RPROMPT=$'$(git_prompt_info)$(git_prompt_short_sha)'
