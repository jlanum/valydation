class SalesController < ApplicationController
  before_filter :handle_device
  before_filter :require_user
 # before_filter :use_test_user

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
                     :user_lon => params[:user_lon],
                     :city_id => @user.city_id )

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
    if params[:my_feed]
      index_mine
    else
      index_all
    end

    render :json => @sales.
      to_json(:include => {:user => User.public_json},
              :methods => [:my_fave])
  end
  
  def index_mine
    @sales = Sale.select(%Q{"sales".*, 
                            "faves"."id" as my_fave_id, 
                            "followers"."id" as follow_id}).
      where(%Q{(("faves"."id" IS NOT NULL) OR ("followers"."id" IS NOT NULL))}).
      joins(%Q{LEFT OUTER JOIN "faves" ON 
               "faves"."sale_id"="sales"."id" AND "faves"."user_id"=#{@user.id} 
               LEFT OUTER JOIN "followers" ON 
               ("followers"."follower_id"=#{@user.id} AND 
                "followers"."following_id"="sales"."user_id")}).
      includes(:user).
      order(%Q{"sales"."created_at" DESC}).
      limit(10).
      offset(params[:offset]).all
  end

  def index_all
    @sales = Sale.where(:category_id => params[:category_id],
                        :city_id => @user.city_id).
      select(%Q{"sales".*, "faves"."id" as my_fave_id}).
      joins(%Q{LEFT OUTER JOIN "faves" ON "faves"."sale_id"="sales"."id" 
               AND "faves"."user_id"=#{@user.id}}).
      includes(:user).
      order(%Q{"sales"."created_at" DESC}).
      limit(10).
      offset(params[:offset]).all
  end

end
