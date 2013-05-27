class CommentsController < ApplicationController
  before_filter :handle_device
  before_filter :require_user
  before_filter :get_cart
  before_filter :view_cart
  def index
    @comments = Comment.where(:sale_id => params[:sale_id]).
      order("created_at ASC").all

    render :json => @comments.to_json(:include => {:user => User.public_json})
  end

  def create
    @sale = Sale.find(params[:sale_id])
    @comment = Comment.new(:user_id => @user.id,
                           :sale_id => @sale.id,
                           :text => params[:text])
    @comment.save!

    respond_to do |wants|
      wants.json { render :json => @comment.to_json }
      wants.html { redirect_to sale_url(@sale.id) }
    end
  end

end
