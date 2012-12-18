class SalesController < ApplicationController

  def create
    @sale = Sale.new(:user_id => 0,
                     :brand => params[:brand],
                     :sale_price => params[:sale_price],
                     :orig_price => params[:orig_price],
                     :percent_off => params[:percent_off],
                     :product => params[:product],
                     :category_id => params[:category_id],
                     :size => params[:size],
                     :store_name => params[:store_name],
                     :store_url => params[:store_url],
                     :display_address => params[:display_address],
                     :address => params[:address],
                     :city => params[:city],
                     :state => params[:state],
                     :postal_code => params[:postal_code],
                     :country => params[:country],
                     :latitude => params[:latitude],
                     :longitude => params[:longitude] )

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
    @sales = Sale.where(:category_id => params[:category_id]).
      order("created_at DESC").
      limit(10).
      offset(params[:offset]).all
    render :json => @sales.to_json
  end

end
