# -*- encoding : utf-8 -*-
require File.join(File.dirname(__FILE__), 'boot')

# uncomment if needed force env
# ENV['APP_ENV'] = 'production'
# or create file config/environment.current (by captistrano for example) and put there string 'production'

require 'ruby-app/environment'

unless File.exist?("#{App.root}/migrated")
  require 'rake'
  require 'rake_tasks/sequel_rake'
  Rake::Task["db:migrate"].invoke
  FileUtils.touch("#{App.root}/migrated")
end
