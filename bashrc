source ~/.dotfiles/env

# Travis
[ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh

# ASDF version manager
source $HOME/.asdf/completions/asdf.bash

# direnv
eval "$(direnv hook bash)"

# added by travis gem
[ -f /Users/patrickoscity/.travis/travis.sh ] && source /Users/patrickoscity/.travis/travis.sh
