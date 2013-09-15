echo "Installing Padde’s dotfiles..."

# update dotfiles and fetch submodules
/usr/bin/env git pull origin master
/usr/bin/env git submodule init
/usr/bin/env git submodule update

# move containing directory to ~/.dotfiles and go there
cp -r . ~/.dotfiles
cd ..
rm -rf dotfiles
cd ~/.dotfiles

# create symlinks
ln -vs ~/.dotfiles/gemrc          ~/.gemrc
ln -vs ~/.dotfiles/gitconfig      ~/.gitconfig
ln -vs ~/.dotfiles/gitignore      ~/.gitignore
ln -vs ~/.dotfiles/hgrc           ~/.hgrc
ln -vs ~/.dotfiles/hgignore       ~/.hgignore
ln -vs ~/.dotfiles/irbrc          ~/.irbrc
ln -vs ~/.dotfiles/latexmkrc      ~/.latexmkrc
ln -vs ~/.dotfiles/tmux.conf      ~/.tmux.conf
ln -vs ~/.dotfiles/vimrc          ~/.vimrc
ln -vs ~/.dotfiles/vimpagerrc     ~/.vimpagerrc
ln -vs ~/.dotfiles/vim/           ~/.vim
ln -vs ~/.dotfiles/zsh/zsh/       ~/.zsh
ln -vs ~/.dotfiles/zsh/zshrc      ~/.zshrc
ln -vs ~/.dotfiles/zsh/zshenv     ~/.zshenv
ln -vs ~/.dotfiles/zsh/oh-my-zsh/ ~/.oh-my-zsh

# fonts for vim powerline
cp -v ~/.dotfiles/fonts/* ~/Library/Fonts/

# vundle
vim +BundleInstall +qall

# install oh-my-zsh
chsh -s `which zsh`
/usr/bin/env zsh
source ~/.zshrc
cd

# fix rvm in vim (see https://github.com/tpope/vim-rvm)
sudo mv -v /etc/zshenv /etc/zshrc

# Powerline
brew update
brew install python
pip install --user git+git://github.com/Lokaltog/powerline

echo "Done."
