function find_index -d "Find index of first occurence in array variable"
  set i 0
  for x in $$argv[1]
    set i (expr $i + 1)
    if test $x = $argv[2]
      echo $i; return 0
    end
  end
  return 1
end

function remove -d "Remove element from array variable"
  set -e $argv[1][(find_index $argv[1] $argv[2])]
end

# Move /usr/local/bin to the front of $PATH
remove PATH "/usr/local/bin"
set -x PATH "/usr/local/bin" $PATH

# Use macvim binary (has clipboard support)
if test -d /Applications/MacVim.app
  function vim
    /Applications/MacVim.app/Contents/MacOS/Vim $argv
  end
else if test -d ~/Applications/MacVim.app
  function vim
    ~/Applications/MacVim.app/Contents/MacOS/Vim $argv
  end
end

# Use Vim!
if which vim > /dev/null
  set -x EDITOR vim
end

if type 'vimpager' > /dev/null
  set -x PAGER vimpager
else if type 'most' > /dev/null
  set -x PAGER most
end

rvm > /dev/null

# Colorize listings (especially in `tree`)
set -x LS_COLORS "no=00:di=34:ln=35:so=33"
set -x LS_COLORS "ex=37;41:$LS_COLORS"
set -x LS_COLORS "*.zip=36:*.rar=36:*.tar=36:*.gz=36:*.tar.gz=36:*.7z=36:$LS_COLORS"
set -x LS_COLORS "*.c=32:*.cc=32:*.cpp=32:*.m=32:*.rb=32:*.pl=32:*.php=32:*.java=32:$LS_COLORS"
set -x LS_COLORS "*.h=33:*.hpp=33:$LS_COLORS"
set -x LS_COLORS "*.o=30:*.d=30:$LS_COLORS"
set -x LS_COLORS "*Makefile=35:*.mk=35:*Rakefile=35:$LS_COLORS"
