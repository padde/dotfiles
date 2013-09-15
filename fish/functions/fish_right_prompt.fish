function fish_right_prompt
  set last_status $status

  set_color black

  if test $last_status != 0
    set_color red
    printf "⚡$last_status "
  end

  if git branch > /dev/null 2>&1
    set_color black
    printf '['

    if test (count (git status --porcelain)) != 0
      set_color red
      printf '●'
    end

    set_color black
    printf 'git:'

    set_color green
    printf '%s' (git rev-parse --abbrev-ref HEAD)

    set_color black
    printf '@'

    set_color yellow
    printf '%s' (git log -1 --format="%h")

    set_color black
    printf ']'
  end

  if hg root > /dev/null 2>&1
    set_color black
    printf '['

    if test (count (hg status)) != 0
      set_color red
      printf '●'
    end

    set_color black
    printf 'hg:'

    set_color green
    printf '%s' (hg branch)

    set_color black
    printf '@'

    set_color yellow
    printf '%s' (hg parents --template="{node}" | cut -c-7)

    set_color black
    printf ']'
  end

  set_color normal
end
