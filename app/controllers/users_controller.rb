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
    @user = User.new(name: params[:name],
                     email: params[:email])
    if params[:fb_id]
      @user.fb_id = params[:fb_id]
      @user.passwd_clear = rand(10000000).to_s
    else
      @user.passwd_clear = params[:passwd_clear]
    end

    @user.save!
    @device.user = @user
    @device.save!

    render :json => @user.to_json
  end

  def update

  end

end
