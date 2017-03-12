App.config.define :development do
  log_level ENV['LOG_LEVEL'] ? ENV['LOG_LEVEL'] : Logger::DEBUG
  ping_interval 5.seconds
  ping_timeout 61.seconds
  orphaned_reckeck 7.seconds
  task_fetch_size 2
  task_fetch_sleep 1.second
end
