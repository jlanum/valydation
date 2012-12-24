class ProfilePhotosController < ApplicationController
  before_filter :handle_device
  before_filter :require_user

  def create
    @user.photo = params[:photo]
    @user.save!
    render :json => @user.to_json
  end
end
