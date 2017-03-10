require 'sequel'

Sequel.extension(:migration)
Sequel::Model.plugin(:timestamps, update_on_create: true)
Sequel::Model.plugin(:validation_helpers)
ENV['DB'] ||= App.default_db
DB = Sequel.connect(ENV['DB'])
DB.extension(:pagination)
