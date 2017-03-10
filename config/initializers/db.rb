require 'sequel'

Sequel.extension(:migration)
Sequel.extension(:pagination)
Sequel::Model.plugin(:timestamps, update_on_create: true)
ENV['DB'] ||= App.default_db
DB = Sequel.connect(ENV['DB'])
