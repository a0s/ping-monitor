ENV["APP_ENV"] = 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'database_cleaner'

Dir[File.join(App.root, %w{spec support ** *.rb})].each { |f| require f }

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
