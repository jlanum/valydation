class FavesController < ApplicationController
  before_filter :handle_device
  before_filter :require_user
  #before_filter :use_test_user

  def index
    @faves = Fave.where(:sale_id => params[:sale_id]).
                  includes(:user).
                  order("created_at DESC").
                  limit(100)
    @faves.each do |fave|
      fave.user.other_user = @user
    end

    respond_to do |wants|
      wants.json do
        render :json => @faves.to_json(:include => {:user => User.public_json_follow})
      end
    end
  end

  def create
    unless @fave = Fave.where(user_id: @user.id, sale_id: params[:sale_id]).first
      @fave = Fave.create!(user_id: @user.id, sale_id: params[:sale_id])
    end

    render json: @fave.to_json
  end

  def destroy
    @fave = Fave.where(user_id: @user.id, id: params[:id]).first
    @fave.destroy

    render json: @fave.to_json
  end

end
