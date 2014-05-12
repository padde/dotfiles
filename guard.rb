begin
  require 'terminal-notifier-guard'
  notification :terminal_notifier
rescue LoadError
end

notification :tmux, change_color: false
