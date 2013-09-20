function nomin
  for f in ~/.config/fish/functions/*prompt.fish
    . $f
  end
end
