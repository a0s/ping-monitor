require 'rubygems'

ENV["BUNDLE_GEMFILE"] = File.expand_path("../../Gemfile", __FILE__)
require 'bundler/setup'

class Application
  class << self
    def root
      @root ||= File.expand_path('../..', __FILE__)
    end

    def name
      'pingmon'
    end

    def default_db
      "postgres://#{App.name}:#{App.name}@localhost/#{App.name}"
    end
  end
end

require 'ruby-app/boot'
require 'pp'
