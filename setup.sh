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
ln -vs ~/.dotfiles/gem/gemrc         ~/.gemrc
ln -vs ~/.dotfiles/git/gitconfig     ~/.gitconfig
ln -vs ~/.dotfiles/git/gitignore     ~/.gitignore
ln -vs ~/.dotfiles/hg/hgrc           ~/.hgrc
ln -vs ~/.dotfiles/input/inputrc     ~/.inputrc
ln -vs ~/.dotfiles/irb/irbrc         ~/.irbrc
ln -vs ~/.dotfiles/latexmk/latexmkrc ~/.latexmkrc
ln -vs ~/.dotfiles/vim/vimrc         ~/.vimrc
ln -vs ~/.dotfiles/vim/vim/          ~/.vim
ln -vs ~/.dotfiles/zsh/zsh/          ~/.zsh
ln -vs ~/.dotfiles/zsh/zshrc         ~/.zshrc
ln -vs ~/.dotfiles/zsh/zshenv        ~/.zshenv
ln -vs ~/.dotfiles/zsh/oh-my-zsh/    ~/.oh-my-zsh

# fonts for vim powerline
cp -v ~/.dotfiles/fonts/* ~/Library/Fonts/

# install oh-my-zsh
chsh -s `which zsh`
/usr/bin/env zsh
source ~/.zshrc
cd

echo "Done."