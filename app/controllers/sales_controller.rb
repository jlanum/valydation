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

    if params[:comment] and params[:comment].size > 0
      @comment = Comment.new(:user_id => 0,
                             :sale_id => @sale.id,
                             :text => params[:comment])
      @comment.save!
    end

    #handle images

    (0..2).each do |i|
      uploaded_file = params["image_#{i}"]
      next unless uploaded_file
      
      @sale.send("image_#{i}=".to_sym, uploaded_file)
      @sale.send("has_image_#{i}=".to_sym, true)
      @sale.save!
    end

    render :json => @sale.to_json
  end

  def index
    sale = Sale.new(:brand => "Brand xyz",
                    :product => "Producto",
                    :sale_price => 75.00,
                    :orig_price => 100.00,
                    :percent_off => 0.25,
                    :category_id => params[:category],
                    :store_name => "Store ABC")

    render :json => (0..9).collect { sale }.to_json
  end

end
