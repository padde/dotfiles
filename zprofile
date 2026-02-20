# MacTeX
if [ -f "/usr/libexec/path_helper" ]; then
  eval `/usr/libexec/path_helper -s`
fi

# Rust
if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

# Go
export GOPATH=$HOME/.go
export PATH=$PATH:/usr/local/opt/go/libexec/bin
export PATH=$PATH:$GOPATH

# Yarn package manager
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Homebrew bin
if [ -d "/opt/homebrew/bin" ]; then
  export PATH="/opt/homebrew/bin:$PATH"
else
  export PATH="/usr/local/sbin:$PATH"
fi

# Travis
[ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh

# MISE version manager
eval "$(mise activate zsh)"

# Completions
autoload -Uz compinit && compinit

# direnv
eval "$(direnv hook zsh)"

# Load Angular CLI autocompletion.
if [ -x "$(command -v ng)" ]; then
  source <(ng completion script)
fi

# Docker Desktop
if [ -f "$HOME/.docker/init-zsh.sh" ]; then
  . "$HOME/.docker/init-zsh.sh"
fi

# Custom bin scripts
export PATH=$HOME/.bin:$PATH
