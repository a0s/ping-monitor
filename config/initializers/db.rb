require 'sequel'

Sequel.extension(:migration)
Sequel::Model.plugin(:timestamps, update_on_create: true)
ENV['DB'] ||= App.default_db
DB = Sequel.connect(ENV['DB'])
DB.extension(:pagination)
