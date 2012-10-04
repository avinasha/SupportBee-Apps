PLATFORM_ENV = ENV["RACK_ENV"] ||= "development"
PLATFORM_ROOT = File.expand_path '../../', __FILE__

require 'bundler'
Bundler.setup

Bundler.require(:default, PLATFORM_ENV.to_sym)

require 'active_support/core_ext/string/inflections'

Dir["#{PLATFORM_ROOT}/lib/**/*.rb"].each { |f| require f }
Dir["#{PLATFORM_ROOT}/apps/*/*.rb"].each { |f| require f }

require "#{PLATFORM_ROOT}/config/environments/#{PLATFORM_ENV}"
require "#{PLATFORM_ROOT}/run_app"
