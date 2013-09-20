function __fast_find_git_root
  git rev-parse --show-toplevel > /dev/null 2>&1
end

function __fast_git_dirty
  test (count (git status --porcelain)) != 0
end

function __fast_git_branch
  git rev-parse --abbrev-ref HEAD
end

function __fast_git_shorthash
  git log -1 --format="%h"
end



function __fast_find_hg_root
  set -l dir (pwd)
  set -e HG_ROOT

  while test $dir != "/"
    if test -f $dir'/.hg/dirstate'
      set -g HG_ROOT $dir"/.hg"
      return 0
    end
    set -l dir (dirname $dir)
  end

  return 1
end

function __fast_hg_dirty
  test (count (hg status --cwd $HG_ROOT)) != 0
end

function __fast_hg_branch
  cat "$HG_ROOT/branch"
end

function __fast_hg_shorthash
  hexdump -n 4 -e '1/1 "%02x"' "$HG_ROOT/dirstate" | cut -c-7
end



function fish_right_prompt
  set last_status $status

  set_color black

  if test $last_status != 0
    set_color red
    printf "⚡$last_status "
  end

  if __fast_find_git_root
    set_color black
    printf '['

    if __fast_git_dirty
      set_color red
      printf '●'
    end

    set_color black
    printf 'git:'

    set_color green
    printf '%s' (__fast_git_branch)

    set_color black
    printf '@'

    set_color yellow
    printf '%s' (__fast_git_shorthash)

    set_color black
    printf ']'
  end


  if __fast_find_hg_root
    set_color black
    printf '['

    if __fast_hg_dirty
      set_color red
      printf '●'
    end

    set_color black
    printf 'hg:'

    set_color green
    printf '%s' (__fast_hg_branch)

    set_color black
    printf '@'

    set_color yellow
    printf '%s' (__fast_hg_shorthash)

    set_color black
    printf ']'
  end

  set_color normal
end
