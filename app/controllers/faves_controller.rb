class FavesController < ApplicationController
  before_filter :handle_device
  before_filter :use_test_user

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
