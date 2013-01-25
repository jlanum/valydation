class Admin::UsersController < ApplicationController
  layout "admin"

  def index
    @users = User.page(params[:page]).
      order("created_at DESC").
      per(10).
      includes([:city, :sales])
  end
end
