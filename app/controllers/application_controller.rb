class ApplicationController < ActionController::Base
  protect_from_forgery

  def self.s3_bucket
    "mst-images-#{Rails.env}"
  end

  def self.aws_access_key
    "AKIAJU4IAXMS575N42IA"
  end

  def self.aws_secret_access_key
    "BatRhFb0WhLfRV4kN7yt3Gxcm75qARENyW7LZt7B"
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
    @user ||= User.find :first
  end

end
