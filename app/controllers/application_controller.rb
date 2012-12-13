class ApplicationController < ActionController::Base
  protect_from_forgery

  def self.s3_bucket
    "mst_images_#{Rails.env}"
  end

end
