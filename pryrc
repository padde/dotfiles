# interesting methods

[Object, Class, Module].each do |klass|
  klass.class_eval do
    define_method :interesting_methods do
      (self.methods - klass.new.methods).sort
    end
  end
end
alias imeth interesting_methods

Pry::Commands.block_command "continue!", "Continue and skip binding.pry until exit" do
  def Pry.start(*); end
  run 'continue'
end

Pry::Commands.block_command 'clear', 'Clear the screen' do
  print "\e[H\e[2J"
end

# vim: ft=ruby
