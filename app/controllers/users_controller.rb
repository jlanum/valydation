class UsersController < ApplicationController
  before_filter :handle_device
  before_filter :use_test_user

  def show
    if params[:id] == "self"
      @show_user = @user
    end

    render :json => @show_user.to_json
  end
end
