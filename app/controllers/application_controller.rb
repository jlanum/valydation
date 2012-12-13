class ApplicationController < ActionController::Base
  protect_from_forgery

  def self.s3_bucket
    "mst-images-#{Rails.env}"
  end

end
