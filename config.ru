require File.expand_path(File.join(File.dirname(__FILE__), %w{config environment}))
require 'ping_monitor'

run PingMonitor
