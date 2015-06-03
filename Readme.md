# Padde's Dotfiles

Because no place is like 127.0.0.1...

## Dependencies

* XCode
* Homebrew
* MacVim

## Installation

    git clone git@github.com:padde/dotfiles.git --recursive
    mv dotfiles ~/.dotfiles
    brew tap Homebrew/bundle && brew bundle
    rcup -v rcrc && rcup -v
    vim +PlugInstall +qall
    chsh -s $(which zsh)
