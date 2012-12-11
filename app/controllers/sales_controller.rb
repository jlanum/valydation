class SalesController < ApplicationController

  def create
    @sale = Sale.new(:user_id => 0,
                     :brand => params[:brand],
                     :sale_price => params[:sale_price],
                     :orig_price => params[:orig_price],
                     :product => params[:product],
                     :category_id => params[:category_id],
                     :store_name => params[:store_name],
                     :store_url => params[:store_url])

    @sale.save!

    if params[:comment].size > 0
      @comment = Comment.new(:user_id => 0,
                             :sale_id => @sale.id,
                             :text => params[:comment])
      @comment.save!
    end

    render :json => @sale.to_json
  end

  def index
    render :json => [].to_json
  end

end
