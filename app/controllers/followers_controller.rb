class FollowersController < ApplicationController
  before_filter :handle_device
  before_filter :require_user  

  def create
    unless @follower = Follower.where(:follower_id => @user.id,
                                      :following_id => params[:following_id]).first
      @follower = Follower.create!(:follower_id => @user.id,
                                   :following_id => params[:following_id])
    end

    render :json => @follower.to_json
  end

  def destroy
    @follower = Follower.where(:follower_id => @user.id,
                               :id => params[:id]).first
    @follower.destroy

    render :json => @follower.to_json
  end

end
