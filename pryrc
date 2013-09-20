# doc commands

Pry.commands.command(/(.+) \?\z/) do |a|
  run "show-doc", a
end

Pry.commands.command(/(.+) \?\?\z/) do |a|
  run "show-source", a
end



# minimalist prompt

Pry.commands.command 'min' do
  $_old_prompt = _pry_.prompt
  $_old_print = _pry_.print
  _pry_.prompt = proc{"\n"}
  _pry_.print = proc{|o,v| o.print "#"; $_old_print.call(o,v) }
end

Pry.commands.command 'nomin' do
  _pry_.prompt = $_pry_old_prompt
  _pry_print = $_pry_old_print
end



# interesting methods

[Object, Class, Module].each do |klass|
  klass.class_eval do
    define_method :interesting_methods do
      (self.methods - klass.new.methods).sort
    end
  end
end
alias imeth interesting_methods
