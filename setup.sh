echo "Installing Padde’s dotfiles..."

# move containing directory to ~/.dotfiles and go there
mv $(cd "$(dirname "$0")"; pwd) ~/.dotfiles
cd ~/.dotfiles

function link_file() {
  if [ -a $2 ]; then        # file already exists
    echo -n "backing up "
    mv -v "$2" "$2.backup"  # make backup
  fi
  ln -vs "~/.dotfiles/$1" "$2"
}

# create symlinks
link_file gem/gemrc         ~/.gemrc
link_file git/gitconfig     ~/.gitconfig
link_file git/gitignore     ~/.gitignore
link_file input/inputrc     ~/.inputrc
link_file irb/irbrc         ~/.irbrc
link_file latexmk/latexmkrc ~/.latexmkrc
link_file vim/vimrc         ~/.vimrc
link_file vim/vim/          ~/.vim
link_file zsh/zsh/          ~/.zsh
link_file zsh/zshrc         ~/.zshrc
link_file zsh/oh-my-zsh/    ~/.oh-my-zsh

# update dotfiles and fetch git submodules
/usr/bin/env git pull origin master
/usr/bin/env git submodule init
/usr/bin/env git submodule update

# install oh-my-zsh
chsh -s `which zsh`
/usr/bin/env zsh
source ~/.zshrc
cd

echo "Done."
