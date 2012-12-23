class UsersController < ApplicationController
  before_filter :handle_device
  #before_filter :use_test_user
  before_filter :require_device
  
  def show
    if params[:id] == "self"
      @show_user = @user
    end

    render :json => @show_user.to_json
  end

  def create
    if params[:log_me_in]
      create_login
    elsif params[:fb_id]
      create_fb
    else
      create_email
    end

    if @error_message
      render_error
    elsif @user.save
      @device.user = @user
      @device.save!
      render :json => @user.to_json
    end
  end

  def create_login
    if @user = User.find_by_email(params[:email])
      unless BCrypt::Password.new(@user.passwd_hash) == params[:passwd_clear]
        @error_message = "Email or password incorrect."
        @user = nil
      end
    else
      @error_message = "Email or password incorrect"
    end
  end

  def create_fb
    fb_graph_id_url = "https://graph.facebook.com/me?fields=id&access_token=#{params[:fb_access_token]}"
    fb_response = JSON.parse(open(fb_graph_id_url).read)
    if (fb_response['id'] == params[:fb_id])
      unless @user = (User.find_by_email(params[:email]) ||
                      User.find_by_fb_id(params[:fb_id]))
        @user = User.new(:first_name => params[:first_name],
                         :last_name => params[:last_name],
                         :email => params[:email],
                         :passwd_clear => rand(10000000).to_s,
                         :city_id => City.find(:first).id)
      end
      @user.fb_id = params[:fb_id]
    else
      raise "FB token hacker!!"
    end
  end

  def create_email
    if User.find_by_email(params[:email])
      @error_message = "There is already a user registered with that email address."
    else
      @user = User.new(:first_name => params[:first_name],
                       :last_name => params[:last_name],
                       :email => params[:email],
                       :passwd_clear => params[:passwd_clear],
                       :city_id => City.find(:first).id)
    end
  end
  

  def update
    [:city_id].each do |attr|
      value = params[attr]
      next if value.nil?

      @user.send("#{attr}=",value)
    end
    
    @user.save!
    
    render :json => @user.to_json
  end

  def render_error
    render :json => {'error' => @error_message},
           :status => 403
  end

end
