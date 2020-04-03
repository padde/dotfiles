#!/usr/bin/env bash
set -euo pipefail

DOTFILES=~/.dotfiles
if [ -d $DOTFILES ]; then
  echo "$DOTFILES already exists! Aborting."
  exit 1
fi

# Fetch dotfiles
git clone https://github.com/padde/dotfiles.git $DOTFILES
cd $DOTFILES

# Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

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
vim +PlugInstall +qall < /dev/tty "$@"

# Install TMUX plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bindings/install_plugins

# Install ASDF version manager
cd "$HOME"
git clone https://github.com/asdf-vm/asdf.git ~/.asdf

# Install Chrome dotfiles
git clone https://github.com/matthewhadley/chromedotfiles.git ~/.chromedotfiles
ln -vs ~/.js ~/.chromedotfiles/chromedotfiles

# Install and use ZSH
ZSH=/usr/local/bin/zsh
if grep -vFxq $ZSH /etc/shells
then
  echo "Adding $ZSH to /etc/shells"
  echo $ZSH | sudo tee -a /etc/shells
fi
sudo chmod -R 755 /usr/local/share/zsh
chsh -s $ZSH
env zsh
# shellcheck source=./zshrc
. ~/.zshrc
