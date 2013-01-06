class CommentsController < ApplicationController
  before_filter :handle_device
  before_filter :require_user
  
  def index
    @comments = Comment.where(:sale_id => params[:sale_id]).
      order("created_at ASC").all

    render :json => @comments.to_json(:include => {:user => User.public_json})
  end

  def create
    @comment = Comment.new(:user_id => @user.id,
                           :sale_id => params[:sale_id],
                           :text => params[:text])
    @comment.save!

    render :json => @comment.to_json
  end

end
