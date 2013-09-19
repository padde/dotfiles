function take -d "Open directory, creating it if it doesn't exist"
  mkdir -p $argv
  cd $argv
end
