class FollowersController < ApplicationController
  before_filter :handle_device
  before_filter :require_user  


  def index
    if params[:following_me]
      index_following_me
    elsif params[:im_following]
      index_im_following
    end
  end

  def index_following_me
    @followers = Follower.where(:following_id => @user.id).
      includes(:following_user).
      order("created_at DESC")
    @followers.each do |f|
      f.following_user.other_user = @user
    end

    render :json => @followers.to_json(:include => {:following_user => User.public_json_follow})
  end

  def index_im_following
    @followers = Follower.where(:follower_id => @user.id).
      includes(:followed_user).
      order("created_at DESC")
    @followers.each do |f|
      f.followed_user.other_user = @user
    end

    render :json => @followers.to_json(:include => {:followed_user => User.public_json_follow})
  end

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
