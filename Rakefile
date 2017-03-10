require File.join(File.dirname(__FILE__), %w{config boot})

load "ruby-app/tasks.rake"

require 'sequel/rake'
Sequel::Rake.configure do
  set :connection, ENV['DB'] || App.default_db
  set :migrations, "#{App.root}/db/migrations"
  set :namespace, 'db'
end
Sequel::Rake.load!

