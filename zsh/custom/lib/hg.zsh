# taken from https://github.com/AlexSatrapa/oh-my-zsh/blob/master/lib/hg.zsh
# TODO: remove this file when hg.zsh was merged into the official repo

# get the name of the branch we are on
function hg_prompt_info() {
  ref=$(hg branch 2> /dev/null) || return
  echo "$ZSH_THEME_HG_PROMPT_PREFIX${ref}$(parse_hg_dirty)$ZSH_THEME_HG_PROMPT_SUFFIX"
}

parse_hg_dirty () {
  if [[ -n $(hg status 2> /dev/null) ]]; then
    echo "$ZSH_THEME_HG_PROMPT_DIRTY"
  else
    echo "$ZSH_THEME_HG_PROMPT_CLEAN"
  fi
}

# Formats prompt string for current hg revision
function hg_prompt_rev() {
  REV=$(hg parents --template="{rev}" 2> /dev/null) && echo "$ZSH_THEME_HG_PROMPT_REV_BEFORE$REV$ZSH_THEME_HG_PROMPT_REV_AFTER"
}

# Formats prompt string for current hg sha
function hg_prompt_short_sha() {
  REV=$(hg parents --template="{node|short}" 2> /dev/null) && echo "$ZSH_THEME_HG_PROMPT_SHA_BEFORE$REV$ZSH_THEME_HG_PROMPT_SHA_AFTER"
}

# get the status of the working tree
hg_prompt_status() {
  INDEX=$(hg status 2> /dev/null)
  STATUS=""
  if $(echo "$INDEX" | grep '^? ' &> /dev/null); then
    STATUS="$ZSH_THEME_HG_PROMPT_UNTRACKED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^A ' &> /dev/null); then
    STATUS="$ZSH_THEME_HG_PROMPT_ADDED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^M ' &> /dev/null); then
    STATUS="$ZSH_THEME_HG_PROMPT_MODIFIED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^R ' &> /dev/null); then
    STATUS="$ZSH_THEME_HG_PROMPT_DELETED$STATUS"
  fi
  echo $STATUS
}

