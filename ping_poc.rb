#!/usr/bin/env ruby
require File.expand_path(File.join(File.dirname(__FILE__), %w{config environment}))

require 'icmp4em'

pings = []
pings << ICMP4EM::ICMPv4.new("8.8.8.8", timeout: 60)
pings << ICMP4EM::ICMPv4.new("8.8.4.4", timeout: 60)

Signal.trap("INT") { EventMachine::stop_event_loop }

module ICMP4EM
  class ICMPv4
    def schedule_one
      raise "EM not running" unless EM.reactor_running?
      self.ping
    end
  end
end

channel_tasks = ::EM::Channel.new
channel_result = ::EM::Channel.new

EM.run do
  locked = []

  EM.defer do
    while true
      ips = ['8.8.8.8', '8.8.4.4'] - locked
      ips.each do |ip|
        channel_tasks.push(ip)
        locked << ip
      end
      sleep(3)
    end
  end

  EM.defer do
    channel_result.subscribe do |ip, msg|
      puts "`#{ip}': `#{msg}'"
      locked -= [ip]
    end
  end

  channel_tasks.subscribe do |ip|
    ping = ICMP4EM::ICMPv4.new(ip, timeout: 60)
    ping.data = 'pingmon'
    ping.on_success { |host, seq, latency| channel_result.push([ip, "SUCCESS from #{host}, sequence number #{seq}, Latency #{latency}ms"]) }
    ping.on_expire { |host, seq, exception| channel_result.push([ip, "FAILURE from #{host}, sequence number #{seq}, Reason: #{exception.to_s}"]) }
    ping.schedule_one
  end
end
