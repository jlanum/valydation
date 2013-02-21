class MerchantsController < ApplicationController
  layout 'prelogin'


  def new

  end

  def create
    if User.where(:email => params[:email]).first
      @error_message = "There is already a user registered with that email address."
    elsif User.where(:custom_slug => params[:custom_slug]).first
      @error_message = "That custom URL is already in use. Please pick another."
    end

    unless params[:tos] == "on"
      @error_message = "You must agree to the Terms of Service."
    end
    
    [:first_name, :last_name, :passwd_clear, :business_name].each do |p_name|
      if params[p_name].nil? or params[p_name].to_s.empty?
        @error_message = "Oops, there was a problem with that."
      end
    end

    unless params[:passwd_clear].to_s.length >= 4 and
           params[:passwd_clear] == params[:passwd_confirm]
      @error_message = "Your password must be at least 4 characters, and you must confirm it."
    end

    if @error_message
      render :action => "new"
    else
      @user = User.new(:is_merchant => true,
                       :email => params[:email],
                       :does_shipping => params[:shipping],
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
