App.config.define :test do
  log_level ENV['LOG_LEVEL'] ? ENV['LOG_LEVEL'] : Logger::INFO
end
