App.config.define :default do
  log_level Logger::INFO
  ping_timeout ENV['PING_TIMEOUT'] ? ENV['PING_TIMEOUT'].to_i : 127
  ping_interval ENV['PING_INTERVAL'] ? ENV['PING_INTERVAL'].to_i : 5
end
