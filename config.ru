# This file is used by Rack-based servers to start the application.

require 'bundler'
Bundler.require

require ::File.expand_path('../config/environment',  __FILE__)
run HiStrollers::Application

