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
    if params[:fb_id]
      create_fb
    else
      create_email
    end

    if @user.save
      @device.user = @user
      @device.save!
      render :json => @user.to_json
    end
  end

  def create_fb
    fb_graph_id_url = "https://graph.facebook.com/me?fields=id&access_token=#{params[:fb_access_token]}"
    fb_response = JSON.parse(open(fb_graph_id_url).read)
    if (fb_response['id'] == params[:fb_id])
      unless @user = (User.find_by_email(params[:email]) ||
                      User.find_by_fb_id(params[:fb_id]))
        @user = User.new(:name => params[:name],
                         :email => params[:email],
                         :passwd_clear => rand(10000000).to_s,
                         :city_id => City.find(:first).id)
      end
      @user.fb_id = params[:fb_id]
    else
      raise "FB token hacker!!"
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
    render :json => {'error' => @error_message}
  end

end
