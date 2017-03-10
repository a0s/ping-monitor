desc 'Start console'
task :console => :environment do
  require 'irb'
  require 'irb/completion'
  require 'pp'
  require 'benchmark'
  ARGV.clear
  IRB.start
end

task :c => :console
