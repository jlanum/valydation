class ApplicationController < ActionController::Base
  protect_from_forgery

  def self.s3_bucket
    "mst-images-#{Rails.env}"
  end

  private

  def handle_device
    @duid = request.headers['X-HS-DUID']
    if @duid
      @device = Device.find_by_duid(@duid)
    end
    if @device
      @user = @device.user
    end
  end

  def require_device
    @device or raise "WTF, no device for you."
  end

  def require_user
    unless @user
      render :json => {"error" => "User not registered."},
             :status => 403
      return false
    end
  end

  def use_test_user
    @user = User.find :first
  end

end
