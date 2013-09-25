function fish_right_prompt
  set last_status $status

  function __fast_find_git_root
    git rev-parse --show-toplevel > /dev/null 2>&1
  end

  function __fast_git_dirty
    test (count (git status --porcelain)) != 0
  end

  function __fast_git_branch
    git rev-parse --abbrev-ref HEAD
  end

  function __fast_git_hash
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
    cat "$HG_ROOT/branch" 2>/dev/null
    or hg branch
  end

  function __fast_hg_hash
    hexdump -n 4 -e '2/1 "%02x"' "$HG_ROOT/dirstate" | cut -c-7
  end


  if not set -q __fish_prompt_color_delimiter
    set -g __fish_prompt_color_delimiter (set_color black)
  end

  if not set -q __fish_prompt_color_laststatus
    set -g __fish_prompt_color_laststatus (set_color red)
  end

  if not set -q __fish_prompt_color_vcs_dirty
    set -g __fish_prompt_color_vcs_dirty (set_color red)
  end

  if not set -q __fish_prompt_color_vcs_branch
    set -g __fish_prompt_color_vcs_branch (set_color green)
  end

  if not set -q __fish_prompt_color_vcs_hash
    set -g __fish_prompt_color_vcs_hash (set_color yellow)
  end

  if not set -q __fish_prompt_color_normal
    set -g __fish_prompt_color_normal (set_color normal)
  end

  if test $last_status != 0
    printf '%s⚡%s' \
      $__fish_prompt_color_laststatus $last_status
  end

  if __fast_find_git_root
    if __fast_git_dirty
      set -g __fish_prompt_git_dirty_str '●'
    else
      set -e __fish_prompt_git_dirty_str
    end

    printf ' %s%s%s%s%s%s%s%s%s%s%s%s%s%s%s' \
      $__fish_prompt_color_delimiter  '[' \
      $__fish_prompt_color_vcs_dirty  $__fish_prompt_git_dirty_str \
      $__fish_prompt_color_delimiter  'git:' \
      $__fish_prompt_color_vcs_branch (__fast_git_branch) \
      $__fish_prompt_color_delimiter  '@' \
      $__fish_prompt_color_vcs_hash   (__fast_git_hash) \
      $__fish_prompt_color_delimiter  ']' \
      $__fish_prompt_color_normal
  end

  if __fast_find_hg_root
    if __fast_hg_dirty
      set -g __fish_prompt_hg_dirty_str '●'
    else
      set -e __fish_prompt_hg_dirty_str
    end

    printf ' %s%s%s%s%s%s%s%s%s%s%s%s%s%s%s' \
      $__fish_prompt_color_delimiter  '[' \
      $__fish_prompt_color_vcs_dirty  $__fish_prompt_hg_dirty_str \
      $__fish_prompt_color_delimiter  'hg:' \
      $__fish_prompt_color_vcs_branch (__fast_hg_branch) \
      $__fish_prompt_color_delimiter  '@' \
      $__fish_prompt_color_vcs_hash   (__fast_hg_hash) \
      $__fish_prompt_color_delimiter  ']' \
      $__fish_prompt_color_normal
  end
end
