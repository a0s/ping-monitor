require 'rubygems'

ENV["BUNDLE_GEMFILE"] = File.expand_path("../../Gemfile", __FILE__)
require 'bundler/setup'

$stdout.sync = true
$stderr.sync = true

class Application
  class << self
    def root
      @root ||= File.expand_path('../..', __FILE__)
    end

    def name
      'pingmonitor'
    end

    def logger
      @logger ||= begin
        logger = Logger.new($stderr)
        logger.level = App.config.log_level
        logger
      end
    end
  end
end

require 'ruby-app/boot'

ENV['RACK_ENV'] = ENV['APP_ENV'] = ENV['RAILS_ENV'] = App.env

require 'pp'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/numeric/time'
require 'calc_stat'
