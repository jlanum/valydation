class SessionsController < ApplicationController
  layout "prelogin"
  before_filter :handle_user, :only => [:new]
  before_filter :require_ssl, :only => [:new, :create]
  before_filter :get_cart
  before_filter :view_cart

  def new
    if @user
      redirect_to sales_url
    else
      render
    end
  end

  def create
    params[:email] = params[:email].downcase

    if @user = (User.where(:email => params[:email]).first or
                User.where(:custom_slug => params[:email]).first)
      unless BCrypt::Password.new(@user.passwd_hash) == params[:passwd_clear]
        @error_message = "Email/Username or password incorrect."
      end
    else
      @error_message = "Email/Username or password incorrect"
    end

    if @error_message
      render :action => "new"
      return
    else
      session[:user_id] = @user.id
      redirect_url = (session[:post_login_url] or sales_url)
      session[:post_login_url] = nil
      redirect_to redirect_url
    end
  end
  
  def forgot_passwd
      @user = User.find_by_email(params[:email])
      random_passwd_hash = Array.new(10).map { (65 + rand(58)).chr }.join
      @user.passwd_hash = random_passwd_hash
      @user.save!
      ShopMailer.create_and_deliver_passwd_change(@user, random_passwd_hash)
      flash[:message] = "Your password has been changed."
      redirect_to :back
    end

  def destroy
    session[:user_id] = nil
    redirect_to '/'
  end

  def login_choice

  end

end
