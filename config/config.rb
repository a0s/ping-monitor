App.config.define :default do
  log_level Logger::INFO
  ping_interval ENV['PING_INTERVAL'] ? ENV['PING_INTERVAL'].to_i : 60.seconds
  ping_timeout ENV['PING_TIMEOUT'] ? ENV['PING_TIMEOUT'].to_i : 127.seconds
  orphaned_reckeck ENV['ORPHANED_RECKECK'] ? ENV['ORPHANED_RECKECK'].to_i : 2.minutes
  task_fetch_size ENV['TASK_FETCH_SIZE'] ? ENV['TASK_FETCH_SIZE'].to_i : 1000
  task_fetch_sleep ENV['TASK_FETCH_SLEEP'] ? ENV['TASK_FETCH_SLEEP'].to_i : 1.0.second
end
