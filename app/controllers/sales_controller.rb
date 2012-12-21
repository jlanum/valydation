class SalesController < ApplicationController
  before_filter :handle_device
  before_filter :use_test_user

  def create
    @sale = Sale.new(:user_id => @user.id,
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
                     :longitude => params[:longitude],
                     :user_lat => params[:user_lat],
                     :user_lon => params[:user_lon] )

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
    @sales.each { |s| s.current_user = @user }

    render :json => @sales.
      to_json(:include => {:user => User.public_json,
                           :comments => {:user => User.public_json}},
              :methods => [:my_fave])
  end

end
