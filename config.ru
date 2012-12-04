# This file is used by Rack-based servers to start the application.

require 'bundler'
Bundler.require

require ::File.expand_path('../config/environment',  __FILE__)
run HiStrollers::Application

Rack::PushNotification::Admin.use Rack::Auth::Basic do |username, password|
  [username, password] == ['admin', "admin"]
end

use Rack::PushNotification::Admin, certificate: "/path/to/apn_certificate.pem",
                                   environment: :production
run Rack::PushNotification
