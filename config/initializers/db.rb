require 'sequel'

Sequel.extension(:migration)
Sequel::Model.plugin(:timestamps, update_on_create: true)
Sequel::Model.plugin(:validation_helpers)
DB = Sequel.connect(App.config.db)
DB.extension(:pagination)
# DB.logger = App.logger
