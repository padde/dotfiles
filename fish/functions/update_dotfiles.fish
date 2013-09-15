function update_dotfiles
  cd ~/.dotfiles
  git pull origin master
  git submodule foreach git pull origin master
  cd -
end
