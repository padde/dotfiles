def shot
  screenshot_and_open_image
end

def browse
  system("open", current_url)
end

Pry::Commands.block_command('continue!', 'Continue and skip binding.pry until exit') do
  def Pry.start(*); end
  run 'continue'
end

Pry::Commands.block_command('clear', 'Clear the screen') do
  print "\e[H\e[2J"
end

Pry::Commands.command(/\A\z/, 'Repeat the last command') do
  _pry_.input = StringIO.new(Pry.history.to_a.last)
end

# vim: ft=ruby
