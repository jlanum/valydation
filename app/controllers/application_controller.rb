class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :detect_iphone

  def self.mandrill_api_key
    'ttWsPAoWdEjbcLoFIqYzxg'
  end

  def self.s3_bucket
    "mst-images-#{Rails.env}"
  end

  def self.aws_access_key
    "AKIAJU4IAXMS575N42IA"
  end

  def self.aws_secret_access_key
    "BatRhFb0WhLfRV4kN7yt3Gxcm75qARENyW7LZt7B"
  end

  def self.google_places_key
    "AIzaSyDoWmAsJFjA4IZxd4IlBpAd_OfZGh15p8k"
  end

  def self.sts
   AWS::STS.new(:access_key_id => aws_access_key,
                :secret_access_key => aws_secret_access_key)  
  end

  def self.new_sts_session
    sts = self.sts
    sts.new_session(:duration => 60*60)
  end

  def self.new_sts_federated_session(federated_user_key)
    sts = self.sts

    policy = AWS::STS::Policy.new
    policy.allow(:actions => ["s3:PutObject"],
                 :resources => :any)

    sts.new_federated_session(federated_user_key, :policy => policy)
  end



  private
  
  def admin_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == "admin" && password == "Green1994"
    end
  end

  def detect_iphone
    if request.env['HTTP_USER_AGENT'].to_s.match(/iPhone/) and not session[:iphone_redirected_from]
      session[:iphone_redirected_from] = request.url
      redirect_to page_url(:slug => "iphone")
      false
    end
  end

  def require_ssl
    if request.ssl? or Rails.env == 'development' 
      true
    else
      redirect_to({:protocol => 'https://'}.merge(params), :flash => flash)
      false
    end
  end

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

  def handle_user
    if session[:user_id]
      begin
        @user = User.find(session[:user_id])
      rescue
        session[:user_id] = nil
      end
    end
  end

  def require_user
    handle_user

    unless @user
      session[:post_login_url] = request.url

      respond_to do |wants|
        wants.json do 
          render :json => {"error" => "User not registered."},
                 :status => 404
        end
        wants.html do
          redirect_to new_session_url
        end
      end
      return false
    end
  end

  def use_test_user
    @user ||= User.find :first
  end

end
