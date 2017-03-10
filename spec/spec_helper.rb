ENV["APP_ENV"] = 'test'
require File.expand_path("../../config/environment", __FILE__)

Dir[File.join(App.root, %w{spec support ** *.rb})].each { |f| require f }

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
end
