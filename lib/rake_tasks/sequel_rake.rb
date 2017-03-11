require 'sequel/rake'
Sequel::Rake.configure do
  set :connection, App.config.db
  set :migrations, "#{App.root}/db/migrations"
  set :namespace, 'db'
end
Sequel::Rake.load!
