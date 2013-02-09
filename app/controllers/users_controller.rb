class UsersController < ApplicationController
  before_filter :handle_device
  #before_filter :use_test_user
  #before_filter :require_device
  before_filter :require_user, :only => [:update, :show, :edit]
  before_filter :handle_user, :only => [:landing, :new]

  def landing
    if @user
      redirect_to sales_url
      return
    end
    render :layout => nil
  end

  def new
    if @user
      redirect_to sales_url
    else
      render :layout => "prelogin"
    end
  end

  def register
    render :layout => "prelogin"
  end

  def show
    if params[:id] == "self"
      if @user
        render :json => @user.to_json(:methods => [:photo_fb, 
                                      :follower_count, 
                                      :following_count])
      else
        render :json => {'error' => "No such user"},
               :status => 404
      end
    else
      if params[:custom_slug]
        if show_user = User.where(:custom_slug => params[:custom_slug]).first
          params[:id] = show_user.id
        else
          raise ActionController::RoutingError.new('Not Found')
          return
        end
      end

      @show_user = User.find(params[:id])
      @show_user.other_user = @user

      respond_to do |wants|
        wants.json do
          render :json => @show_user.
        to_json({:only => [:id, :first_name, :last_name, :bio],
                 :methods => [:photo_fb, :is_followed, :follower_count, :following_count]})
        end

        wants.html do
          @sales = Sale.select(%Q{"sales".*, "faves"."id" as my_fave_id}).
            where(:user_id => params[:id],
                  :visible => true).
            joins(%Q{LEFT OUTER JOIN "faves" ON "faves"."sale_id"="sales"."id" 
                                 AND "faves"."user_id"=#{@user.id}}).
            includes(:user).
            order(%Q{"sales"."created_at" DESC}).
            page(params[:page]).
            per(8)
          render 
        end
      end

    end
  end

  def create
    respond_to do |wants|
      wants.html { create_html }
      wants.json { create_json }
    end
  end

  def create_html
    if params[:fb_id]
      create_fb
    else
      create_email
    end

    if @error_message
      render :layout => "prelogin", :action => "new"
      return
    end

    @user.save!

    session[:user_id] = @user.id

    redirect_to sales_url
  end

  def create_json
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
    fb_graph_id_url = "https://graph.facebook.com/me?fields=id,email,first_name,last_name&access_token=#{params[:fb_access_token]}"
    fb_response = JSON.parse(open(fb_graph_id_url).read)
    if (fb_response['id'] == params[:fb_id])
      unless @user = (User.find_by_email(fb_response['email']) ||
                      User.find_by_fb_id(params[:fb_id]))
        @user = User.new(:first_name => fb_response['first_name'],
                         :last_name => fb_response['last_name'],
                         :email => fb_response['email'].downcase,
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

  def edit
    
  end

  def update
    if params[:passwd_new]
      change_passwd
      return
    end

    if params[:email] and params[:email] != @user.email
      if User.where(:email => params[:email]).first
        @error_message = "There is already a user registered with that email address."
        return render_error
      end
    end

    if params[:custom_slug] and params[:custom_slug] != @user.custom_slug
      if User.where(:custom_slug => params[:custom_slug]).first
        @error_message = "That custom URL is already in use. Please try antoher."
        return render_error
      end
    end

    if params[:first_name] and params[:first_name].empty?
      @error_message = "Please provide your first name."
      return render_error
    end

    if params[:last_name] and params[:last_name].empty?
      @error_message = "Please provide your last name."
      return render_error
    end

    if params[:bio] and params[:bio].length > 150
      @error_message = "Your bio must be 150 characters or shorter."
      return render_error
    end

    [:city_id, 
     :bio, 
     :notify_faved, 
     :notify_followed, 
     :notify_posted,
     :notify_comment,
     :email,
     :custom_slug,
     :zip_code,
     :first_name,
     :last_name,
     :gender,
     :photo
    ].each do |attr|

      value = params[attr]
      next if value.nil?

      @user.send("#{attr}=",value)
    end
    
    @user.save!
     
    if params[:detach_device]
      @user.detach_devices!(true)
    end 

    respond_to do |wants|
      wants.json { render :json => @user.to_json }
      wants.html { 
        flash[:message] = "Your profile has been updated."
        redirect_to sales_url
      }
    end

  end

  def change_passwd
    if BCrypt::Password.new(@user.passwd_hash) == params[:passwd_clear]
      @user.passwd_clear = params[:passwd_new]
      @user.save!
      respond_to do |wants|
        wants.json { render :json => @user.to_json }
        wants.html do
          flash[:message] = "Your password has been changed."
          redirect_to sales_url
        end
      end
    else
      @error_message = "Password incorrect."
      render_error
    end
  end

  def render_error
    respond_to do |wants|
      wants.json do 
        render :json => {'error' => @error_message},
               :status => 403
      end
      wants.html do
        render :action => "edit"
      end
    end
  end

end
