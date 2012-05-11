sb_apps_root = File.expand_path '../../', __FILE__

ENV["RACK_ENV"] ||= "development"

require 'bundler'
Bundler.setup

Bundler.require(:default, ENV["RACK_ENV"].to_sym)

Dir["./lib/**/*.rb"].each { |f| require f }
Dir["./apps/**/*.rb"].each { |f| require f }

require "#{sb_apps_root}/run_app"
