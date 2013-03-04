class SalesController < ApplicationController
  before_filter :handle_device
  before_filter :require_user
 # before_filter :use_test_user

  def show
    @sale = Sale.where(:id => params[:id], :visible => true).
      select(%Q{"sales".*, "faves"."id" as my_fave_id}).
      joins(%Q{LEFT OUTER JOIN "faves" ON "faves"."sale_id"="sales"."id" 
               AND "faves"."user_id"=#{@user.id}}).
      includes(:user).
      first
  end

  def new
    if params[:bucket] and params[:key]
      handle_s3_upload
    end

    @uploader_0 = Sale.new.image_0
    @uploader_0.success_action_redirect = new_sale_url

    @uploader_1 = Sale.new.image_1
    @uploader_1.success_action_redirect = new_sale_url

    @uploader_2 = Sale.new.image_2
    @uploader_2.success_action_redirect = new_sale_url
  end

  def handle_s3_upload
    render :json => {"bucket" => params[:bucket], "key" => params[:key]}
  end

  def store_lookup
    autocomplete_url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=#{CGI.escape(params[:store])}&types=establishment&location=#{@user.city.lat},#{@user.city.lon}&radius=10000&sensor=false&key=#{ApplicationController.google_places_key}"
    json_response = JSON.parse(open(autocomplete_url).read)
    render :json => json_response
  end

  def handle_store_reference
    if params[:store_reference]
      place_url = "https://maps.googleapis.com/maps/api/place/details/json?key=#{ApplicationController.google_places_key}&reference=#{params[:store_reference]}&sensor=false"
      json_response = JSON.parse(open(place_url).read)

      params[:display_address] = json_response["result"]["formatted_address"]
      params[:store_name] = json_response["result"]["name"]
      params[:store_url] = params[:store_reference]
      params[:latitude] = json_response["result"]["geometry"]["location"]["lat"]
      params[:longitude] = json_response["result"]["geometry"]["location"]["lng"]

      params[:percent_off] = params[:percent_off].to_f / 100
    end
  end

  def handle_direct_uploaded_images
    (0..2).each do |image_index|
      if image_key = params["image_#{image_index}_key"] and not image_key.empty?
        @sale.send("temp_image_url_#{image_index}=",image_key)
        @sale.uploaded_images = true
      end
    end    
  end

  def create_s3_uploads
    @sale.image_upload_urls = []
    federated_session = ApplicationController.new_sts_federated_session("mst_user_#{@user.id}")
    params[:num_images].to_i.times do 
      puts "creating image upload url"
      @sale.image_upload_urls << @sale.create_s3_image_upload(federated_session)
    end    
  end

  def create
    handle_store_reference

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
                     :city_id => @user.city_id,
                     :allow_returns => (params[:allow_returns].to_i==1),
                     :does_shipping => (params[:does_shipping].to_i==1) )

    if params[:comment] and params[:comment].size > 0
      comment = Comment.new(:user_id => @user.id,
                            :text => params[:comment])
      @sale.comments << comment
    end

    handle_direct_uploaded_images
    
    @sale.save!

    create_s3_uploads

    respond_to do |wants|
      wants.json do
        render :json => @sale.to_json(:methods => [:image_upload_urls])        
      end
      wants.html do
        redirect_to sales_url
      end
    end
  end

  def update
    @sale = Sale.where(:id => params[:id], :user_id => @user.id).first

    uploaded_images = false

    (0..2).each do |image_index|
      if image_key = params[:image_uploaded_keys][image_index.to_s]
        
        @sale.send("temp_image_url_#{image_index}=","raw_uploads/#{image_key}")
        uploaded_images = true
      end
    end

    @sale.uploaded_images = uploaded_images    
    @sale.save!

    render :json => @sale.to_json
  end


  def index
    respond_to do |wants|
      wants.json { index_json }
      wants.html { index_html }
    end
  end


  private


  def index_html
    @cities = City.order("name ASC").all
    if params[:my_feed]
      index_html_mine
    else
      index_html_all
    end    
  end

  def index_html_all
    params[:category_id] ||= 0

    if @user.is_merchant and (Time.now - @user.created_at) < 1.day and 
      not session[:merchant_modal]
      @merchant_modal = true
      session[:merchant_modal] = true
    end

    @sales = all_sales.
      page(params[:page]).
      per(16)

    if request.xhr?
      render_lazy_rows
    end
  end

  def index_html_mine
    @sales = Sale.select(%Q{"sales".*, 
                            "faves"."id" as my_fave_id}).
      where(%Q{"sales"."visible"=true AND 
               "faves"."id" IS NOT NULL}).
      joins(%Q{LEFT OUTER JOIN "faves" ON 
               "faves"."sale_id"="sales"."id" AND "faves"."user_id"=#{@user.id}}).
      includes(:user).
      order(%Q{"sales"."created_at" DESC}).
      page(params[:page]).
      per(16)    

    if request.xhr?
      render_lazy_rows
    else
      render :template => "sales/mine"
    end
  end

  def render_lazy_rows
    if @sales.empty?
      render :text => ""
    else
      render :layout => false, :partial => "sales/sale_rows"
    end
  end

  def index_json
    if params[:my_feed]
      index_mine
    elsif params[:user_id]
      index_user
    elsif params[:store_id]
      index_store
    elsif params[:brand_id]
      index_brand
    else
      index_all
    end

    render :json => @sales.
      to_json(:include => {:user => User.public_json},
              :methods => [:my_fave])
  end
  
  def index_mine
    @sales = Sale.select(%Q{"sales".*, 
                            "faves"."id" as my_fave_id}).
      where(%Q{"sales"."visible"=true AND 
               "faves"."id" IS NOT NULL}).
      joins(%Q{LEFT OUTER JOIN "faves" ON 
               "faves"."sale_id"="sales"."id" AND "faves"."user_id"=#{@user.id}}).
      includes(:user).
      order(%Q{"sales"."created_at" DESC}).
      limit(10).
      offset(params[:offset]).all
  end

  def index_user
    @sales = Sale.select(%Q{"sales".*, "faves"."id" as my_fave_id}).
      where(:user_id => params[:user_id],
            :visible => true).
      joins(%Q{LEFT OUTER JOIN "faves" ON "faves"."sale_id"="sales"."id" 
                           AND "faves"."user_id"=#{@user.id}}).
      includes(:user).
      order(%Q{"sales"."created_at" DESC}).
      limit(10).
      offset(params[:offset]).all
  end

  def index_store
    @sales = Sale.where(:store_id => params[:store_id],
                       # :city_id => @user.city_id,
                        :visible => true).
                  select(%Q{"sales".*, "faves"."id" as my_fave_id}).
                  joins(%Q{LEFT OUTER JOIN "faves" ON "faves"."sale_id"="sales"."id" 
                           AND "faves"."user_id"=#{@user.id}}).
                  includes(:user).
                  order(%Q{"sales"."created_at" DESC}).
                  limit(10).
                  offset(params[:offset]).all
  end
  
  def index_brand
    @sales = Sale.where(:brand_id => params[:brand_id],
                        #:city_id => @user.city_id,
                        :visible => true).
                  select(%Q{"sales".*, "faves"."id" as my_fave_id}).
                  joins(%Q{LEFT OUTER JOIN "faves" ON "faves"."sale_id"="sales"."id" 
                           AND "faves"."user_id"=#{@user.id}}).
                  includes(:user).
                  order(%Q{"sales"."created_at" DESC}).
                  limit(10).
                  offset(params[:offset]).all
  end

  def index_all(limit = 10)
    @sales = all_sales.
      limit(limit).
      offset(params[:offset]).all
  end

  def all_sales
    where_conditions = {
      :category_id => params[:category_id],
      :visible => true
    }

    if params[:size] and not params[:size].empty?
      where_conditions.update({:sizes => [params[:size]].to_postgres_array})
    end
    if params[:city_id] and not params[:city_id].empty?
      where_conditions.update({:city_id => params[:city_id]})
    end

    curated_sales = Sale.where(where_conditions.merge({
       :editors_pick => true})).
      select(%Q{sales.id}).
      order(%Q{"sales"."created_at" DESC}).
      limit(16)

    curated_select = ["sales.*", "faves.id as my_fave_id"]
    curated_order = "sales.created_at DESC"
    
    unless curated_sales.empty?
      curated_select << "sales.id IN (#{curated_sales.collect(&:id).join(',')}) as curated"
      curated_order = "curated DESC, #{curated_order}"
    end

    @sales = Sale.where(where_conditions).
      select(curated_select).
      joins(%Q{LEFT OUTER JOIN "faves" ON "faves"."sale_id"="sales"."id" 
               AND "faves"."user_id"=#{@user.id}}).
      includes(:user).
      order(curated_order)
  end

end
