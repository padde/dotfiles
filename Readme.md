# Padde's Dotfiles

Because no place is like 127.0.0.1...

## Dependencies

* XCode
* Homebrew
* MacVim

## Installation

    git clone git@github.com:padde/dotfiles.git
    mv dotfiles ~/.dotfiles
    brew bundle ~/.dotfiles/Brewfile
    rcup -d ~/.dotfiles -x Readme.md -x Brewfile
    vim +BundleInstall +qall
    chsh -s $(which zsh)
