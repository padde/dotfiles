function fish_prompt
  set_color black
  printf '%s ' (date "+%H:%M:%S")

  set_color blue
  printf '%s' $USER

  set_color black
  printf '@'

  set_color blue
  printf '%s' $__fish_prompt_hostname

  set_color black
  printf ':'

  set_color red
  printf '%s' (prompt_pwd)

  set_color black
  printf '$ '

  set_color normal
end