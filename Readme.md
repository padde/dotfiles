# Padde's Dotfiles

Because no place is like 127.0.0.1...

## Dependencies

* XCode
* Homebrew
* MacVim

## Installation

    git clone git@github.com:padde/dotfiles.git --recursive
    mv dotfiles ~/.dotfiles
    brew tap Homebrew/bundle
    brew bundle
    rcup rcrc && rcup
    vim +PlugInstall +qall
    chsh -s $(which zsh)
