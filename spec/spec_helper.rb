ENV['RACK_ENV'] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/load")

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
  conf.mock_with :flexmock
end
