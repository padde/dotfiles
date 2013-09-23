function fish_prompt
  if not set -q __fish_prompt_hostname
    set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
  end

  if not set -q __fish_prompt_color_delimiter
    set -g __fish_prompt_color_delimiter (set_color black)
  end

  if not set -q __fish_prompt_color_username
    set -g __fish_prompt_color_username (set_color blue)
  end

  if not set -q __fish_prompt_color_hostname
    set -g __fish_prompt_color_hostname (set_color blue)
  end

  if not set -q __fish_prompt_color_pwd
    set -g __fish_prompt_color_pwd (set_color red)
  end

  if not set -q __fish_prompt_color_normal
    set -g __fish_prompt_color_normal (set_color normal)
  end

  printf '%s%s %s%s%s%s%s%s%s%s%s%s%s%s%s ' \
    $__fish_prompt_color_delimiter (date "+%H:%M:%S") \
    $__fish_prompt_color_username  $USER \
    $__fish_prompt_color_delimiter '@' \
    $__fish_prompt_color_hostname  $__fish_prompt_hostname \
    $__fish_prompt_color_delimiter ':' \
    $__fish_prompt_color_pwd       (prompt_pwd) \
    $__fish_prompt_color_delimiter '$' \
    $__fish_prompt_color_normal
end
