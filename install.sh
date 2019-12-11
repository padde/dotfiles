#!/usr/bin/env sh
set -euo pipefail

DOTFILES=~/.dotfiles
if [ -d $DOTFILES ]; then
  echo "$DOTFILES already exists! Aborting."
  exit 1
fi

# Fetch dotfiles
git clone https://github.com/padde/dotfiles.git $DOTFILES
cd $DOTFILES

# Install homebrew packages
brew update
brew tap Homebrew/bundle
brew bundle

# Symlink dotfiles
rcup -v rcrc
rcup -v

# Install Vim plugins
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
exec vim +PlugInstall +qall < /dev/tty "$@"

# Install TMUX plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bindings/install_plugins

# Install ASDF version manager
cd $HOME
git clone https://github.com/asdf-vm/asdf.git ~/.asdf

# Install and use ZSH
ZSH=/usr/local/bin/zsh
if grep -vFxq $ZSH /etc/shells
then
  echo "Adding $ZSH to /etc/shells"
  echo $ZSH | sudo tee -a /etc/shells
fi
chsh -s $ZSH
env zsh
. ~/.zshrc
