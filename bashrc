# shellcheck source=./aliases
source ~/.dotfiles/aliases

# Travis
[ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh

# ASDF version manager
source "$HOME/.asdf/completions/asdf.bash"

# direnv
eval "$(direnv hook bash)"

source /Users/pat/.docker/init-bash.sh || true # Added by Docker Desktop

# local configuration
if [ -f ~/.bashrc.local ]; then
  source ~/.bashrc.local
fi
