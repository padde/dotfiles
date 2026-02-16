# shellcheck source=./aliases
source ~/.dotfiles/aliases

# Travis
[ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh

# direnv
eval "$(direnv hook bash)"

source /Users/pat/.docker/init-bash.sh || true # Added by Docker Desktop

# local configuration
if [ -f ~/.bashrc.local ]; then
  source ~/.bashrc.local
fi
