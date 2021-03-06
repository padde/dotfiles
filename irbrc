require 'rubygems'
require 'irb/ext/save-history'

# save history
ARGV.concat [ "--readline", "--prompt-mode", "simple" ]
IRB.conf[:SAVE_HISTORY] = 10000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-save-history"

# define and use own prompt mode
IRB.conf[:PROMPT][:PADDE] = {
  :RETURN      => "=> %s\n",
  :PROMPT_I    => "%03n> ",   # normal prompt
  :PROMPT_C    => "%03n> ",   # code continuation
  :PROMPT_N    => "%03n> ",   # ?
  :PROMPT_S    => "%03n  "    # string continuation
}
IRB.conf[:PROMPT_MODE] = :PADDE

# colorize irb
begin
  require 'matisse/autoload'
rescue LoadError; end

# colorized p command
begin
  require 'awesome_print'
rescue LoadError; end

# please only interesting methods!
[Object, Class, Module].each do |klass|
  klass.class_eval do
    define_method :interesting_methods do
      (self.methods - klass.new.methods).sort
    end
  end
end
alias imeth interesting_methods

# quick benchmarking
def quick_benchmark(repetitions=100, &block)
  require 'benchmark'

  Benchmark.bmbm do |b|
    b.report do
      repetitions.times(&block)
    end
  end
  nil
end
