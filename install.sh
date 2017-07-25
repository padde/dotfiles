DOTFILES=~/.dotfiles
if [ -d $DOTFILES ]; then
  echo "$DOTFILES already exists! Aborting."
  exit 1
fi

# Fetch dotfiles
git clone git@github.com:padde/dotfiles.git $DOTFILES
cd $DOTFILES

# Install homebrew packages
brew update
brew tap Homebrew/bundle
brew bundle

# Symlink dotfiles
rcup -v rcrc
rcup -v

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

# Install Vim plugins
exec vim +PlugInstall +qall < /dev/tty "$@"

# Install ASDF version manager
cd $HOME
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.3.0
