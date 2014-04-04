# interesting methods

[Object, Class, Module].each do |klass|
  klass.class_eval do
    define_method :interesting_methods do
      (self.methods - klass.new.methods).sort
    end
  end
end
alias imeth interesting_methods



# vim: ft=ruby
