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
