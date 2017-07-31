Pry::Commands.block_command('continue!', 'Continue and skip binding.pry until exit') do
  def Pry.start(*); end
  run 'continue'
end

Pry::Commands.block_command('clear', 'Clear the screen') do
  print "\e[H\e[2J"
end

# vim: ft=ruby
