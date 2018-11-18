source ~/.dotfiles/env

# Travis
[ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh

# ASDF version manager
source $HOME/.asdf/completions/asdf.bash

# direnv
eval "$(direnv hook bash)"
