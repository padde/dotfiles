# Padde’s Dotfiles

Because there’s no place like `::1`

## Dependencies

* Homebrew
* XCode
* Command Line Tools
* MacVim

## Installation

    git clone git@github.com:padde/dotfiles.git --recursive
    mv dotfiles ~/.dotfiles
    brew tap Homebrew/bundle && brew bundle
    rcup -v rcrc && rcup -v
    vim +PlugInstall +qall
    chsh -s $(which zsh)
