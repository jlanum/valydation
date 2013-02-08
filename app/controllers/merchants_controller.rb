class MerchantsController < ApplicationController
  layout 'prelogin'

  def intro

  end

  def new

  end

  def create
    if User.where(:email => params[:email]).first
      @error_message = "There is already a user registered with that email address."
    elsif User.where(:custom_slug => params[:custom_slug]).first
      @error_message = "That custom URL is already in use. Please pick another."
    end

    if @error_message
      render :action => "new"
    else
      @user = User.new(:is_merchant => true,
                       :email => params[:email],
                       :first_name => params[:first_name],
                       :last_name => params[:last_name],
                       :passwd_clear => params[:passwd_clear],
                       :business_name => params[:business_name],
                       :custom_slug => params[:custom_slug],
                       :bio => params[:bio],
                       :website_url => params[:website_url])
      @user.photo = params[:photo]
      @user.save!

      session[:user_id] = @user.id

      redirect_to sales_url
    end
  end

end
