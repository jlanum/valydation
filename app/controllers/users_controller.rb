class UsersController < ApplicationController
  before_filter :handle_device
  #before_filter :use_test_user
  before_filter :require_device
   

  def show
    if params[:id] == "self"
      @show_user = @user
      render :json => @show_user.to_json(:methods => [:photo_fb, 
                                                      :follower_count, 
                                                      :following_count])
    else
      @show_user = User.find(params[:id])
      @show_user.other_user = @user
      render :json => @show_user.
        to_json({:only => [:id, :first_name, :last_name, :bio],
                 :methods => [:photo_fb, :is_followed]})
    end
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
      return
    end

    if @user
      @user.notify_posted = true
      @user.notify_followed = true
      @user.notify_faved = true
      @user.notify_comment = true

      if @user.save
        @device.user = @user
        @device.save!
        render :json => @user.to_json
      end
    end
  end

  def create_login
    if @user = User.find_by_email(params[:email].downcase)
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
                         :email => params[:email].downcase,
                         :passwd_clear => rand(10000000).to_s,
                         :city_id => City.find(:first).id)
      end
      @user.fb_id = params[:fb_id]
    else
      raise "FB token hacker!!"
    end
  end

  def create_email
    if User.find_by_email(params[:email].downcase)
      @error_message = "There is already a user registered with that email address."
    else
      @user = User.new(:first_name => params[:first_name],
                       :last_name => params[:last_name],
                       :email => params[:email].downcase,
                       :passwd_clear => params[:passwd_clear],
                       :city_id => City.find(:first).id)
    end
  end
  

  def update
    if params[:passwd_new]
      change_passwd
      return
    end

    [:city_id, 
     :bio, 
     :notify_faved, 
     :notify_followed, 
     :notify_posted,
     :notify_comment].each do |attr|

      value = params[attr]
      next if value.nil?

      @user.send("#{attr}=",value)
    end
    
    @user.save!
     
    if params[:detach_device]
      @user.detach_devices!(true)
    end 

    render :json => @user.to_json
  end

  def change_passwd
    if BCrypt::Password.new(@user.passwd_hash) == params[:passwd_clear]
      @user.passwd_clear = params[:passwd_new]
      @user.save!
      render :json => @user.to_json
    else
      @error_message = "Password incorrect."
      render_error
    end
  end

  def render_error
    render :json => {'error' => @error_message},
           :status => 403
  end

end
