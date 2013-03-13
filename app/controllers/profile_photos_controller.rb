class ProfilePhotosController < ApplicationController
  before_filter :handle_device
  before_filter :require_user
  skip_before_filter :detect_iphone

  def create
    @user.photo = params[:photo]
    @user.save!
    render :json => @user.to_json
  end
end
