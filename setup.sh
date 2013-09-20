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

# eat fish!
echo `which fish` | sudo tee -a /etc/shells
chsh -s `which fish`
/usr/bin/env fish
mkdir -p ~/.config
cd

# create symlinks
ln -vs ~/.dotfiles/gemrc          ~/.gemrc
ln -vs ~/.dotfiles/gitconfig      ~/.gitconfig
ln -vs ~/.dotfiles/gitignore      ~/.gitignore
ln -vs ~/.dotfiles/hgrc           ~/.hgrc
ln -vs ~/.dotfiles/hgignore       ~/.hgignore
ln -vs ~/.dotfiles/irbrc          ~/.irbrc
ln -vs ~/.dotfiles/pryrc          ~/.pryrc
ln -vs ~/.dotfiles/latexmkrc      ~/.latexmkrc
ln -vs ~/.dotfiles/tmux.conf      ~/.tmux.conf
ln -vs ~/.dotfiles/vimrc          ~/.vimrc
ln -vs ~/.dotfiles/vimpagerrc     ~/.vimpagerrc
ln -vs ~/.dotfiles/vim/           ~/.vim
ln -vs ~/.dotfiles/fishrc         ~/.fishrc
mkdir -p ~/.config/fish
mv -v  ~/.config/fish/            ~/.config/fish.bak
ln -vs ~/.dotfiles/fish           ~/.config/fish

# fonts for vim powerline
cp -v ~/.dotfiles/fonts/* ~/Library/Fonts/

# vundle
vim +BundleInstall +qall

echo "Done."
