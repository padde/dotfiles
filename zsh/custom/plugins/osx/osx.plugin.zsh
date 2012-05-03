# inherit from the default osx plugin
source $ZSH/plugins/osx/osx.plugin.zsh

# make completion work (is there a better way?)
fpath=(~/.oh-my-zsh/custom/plugins/osx $fpath)

# add untrash function
function untrash() {
  for trashed_file in $@; do
    echo "untrashing ${trashed_file}"
    cp ~/.Trash/$trashed_file .
  done
}