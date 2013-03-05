class SessionsController < ApplicationController
  layout "prelogin"
  before_filter :handle_user, :only => [:new]
  before_filter :require_ssl, :only => [:new, :create]

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
      redirect_to sales_url
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/'
  end

  def login_choice

  end

end
