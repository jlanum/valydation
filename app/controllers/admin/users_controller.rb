class Admin::UsersController < ApplicationController
  http_basic_authenticate_with :name => "admin", :password => "Green1994"
  
  layout "admin"

  def index
    @users = User.page(params[:page]).
      order("created_at DESC").
      per(50).
      includes([:city, :sales])
  end

  def show
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    flash[:message] = "The user has been deleted"
    redirect_to admin_users_url
  end
end
