class SalesController < ApplicationController
  before_filter :handle_device
  before_filter :require_user
  before_filter :admin_auth, :except => [:show, :index, :group]
  
 # before_filter :use_test_user
 def add_to_cart
     @cart = get_cart
     @cart.add_to_cart(Sale.find(:sale_id => params[:sale_id]))
   end

   def get_cart
     if session[:cart]
       return session[:cart]
     else
       session[:cart] = Cart.new
       return session[:cart]
     end
   end

   def clear
     @items.clear
   end

  def show
    @sale = Sale.where(:id => params[:id], :visible => true).
      select(%Q{"sales".*, "faves"."id" as my_fave_id}).
      joins(%Q{LEFT OUTER JOIN "faves" ON "faves"."sale_id"="sales"."id" 
               AND "faves"."user_id"=#{@user.id}}).
      includes(:user).
      first

    respond_to do |wants|
      wants.json do 
        render :json => @sale.to_json(:include => {:user => User.public_json},
                                      :methods => [:my_fave])
      end
      wants.html { }
    end
  end


  def edit
    @cities = City.order("name ASC").all    
    @sale = Sale.where(:user_id => @user.id,
                       :id => params[:id]).first
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
    
    @uploader_3 = Sale.new.image_3
    @uploader_3.success_action_redirect = new_sale_url

    @uploader_4 = Sale.new.image_4
    @uploader_4.success_action_redirect = new_sale_url

    @uploader_5 = Sale.new.image_5
    @uploader_5.success_action_redirect = new_sale_url
    
    @uploader_6 = Sale.new.image_6
    @uploader_6.success_action_redirect = new_sale_url

    @uploader_7 = Sale.new.image_7
    @uploader_7.success_action_redirect = new_sale_url

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
    if params[:store_url] and params[:store_reference].to_s.empty?
      params[:store_reference] = params[:store_url]
    end

    if params[:store_reference]
      place_url = "https://maps.googleapis.com/maps/api/place/details/json?key=#{ApplicationController.google_places_key}&reference=#{params[:store_reference]}&sensor=false"
      json_response = JSON.parse(open(place_url).read)

      params[:display_address] = json_response["result"]["formatted_address"]
      params[:store_name] = json_response["result"]["name"][0..254]
      params[:store_url] = params[:store_reference][0..254]
      params[:latitude] = json_response["result"]["geometry"]["location"]["lat"]
      params[:longitude] = json_response["result"]["geometry"]["location"]["lng"]

      addy = json_response["result"]["address_components"]

      if locality_hash = addy.find { |h| h["types"].include?("locality") }
        params[:city] = locality_hash["long_name"]
      end
  
      if state_hash = addy.find { |h| h["types"].include?("administrative_area_level_1") }
        params[:state] = state_hash["long_name"]
      end
    end

    if params[:percent_off].to_f > 1.0
      params[:percent_off] = params[:percent_off].to_f / 100
    end
  end

  def handle_direct_uploaded_images
    (0..7).each do |image_index|
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
    
    [:allow_returns, :does_shipping].each do |p|
      if params[p].respond_to?(:to_i)
        params[p] = (params[p].to_i == 1)
      end
    end

    @sale = Sale.new(:user_id => @user.id,
                     :brand => params[:brand],
                     :sale_price => params[:sale_price],
                     :orig_price => params[:orig_price],
                     :percent_off => params[:percent_off],
                     :product => params[:product],
                     :category_id => params[:category_id],
                     :size => params[:size],
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
                     :validated => params[:validated],
                     :condition => params[:condition],
                     :city_id => @user.city_id,
                     :source => params[:source],
                     :product_history => params[:product_history],
                     :allow_returns => params[:allow_returns],
                     :does_shipping => params[:does_shipping] )
   
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

    if params[:image_uploaded_keys]
      handle_uploaded_image_keys
      return
    end

    safe_params = [:brand, :product, :category_id, :size, :city_id, :orig_price, :sale_price, :percent_off_int, :allow_returns, :does_shipping, :sold_out, :source, :shipping_price, :tax_cost, :product_history, :condition]

    merge_params = safe_params.inject({}) do |h,p|
      h[p] = params[:sale][p]
      h
    end

    @sale.update_attributes(merge_params)
    @sale.save!

    flash[:message] = "The sale has been updated."
  
    redirect_to edit_sale_url(@sale)
  end

  def handle_uploaded_image_keys
    uploaded_images = false

    (0..7).each do |image_index|
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


  def group
    @group = SaleGroup.where(:slug => params[:slug]).first
    @sales = all_sales.where(:sale_group_id => @group.id).
      page(params[:page]).
      per(16)

    if request.xhr?
      render_lazy_rows
    else
      render :template => "sales/group"
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
    elsif params[:q]
      index_search
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

  def index_search
    @brands = Brand.select(%Q{DISTINCT brands.id,brands.name}).
      #where(["name ILIKE ? AND sales.city_id=?","#{params[:q]}%",@user.city_id]).
      where(["(name ILIKE ?) OR (name ILIKE ?)","#{params[:q]}%", params[:q]]).
      joins(%Q{INNER JOIN "sales" on "sales"."brand_id"="brands"."id"}).
      limit(20)

    @stores = Store.select(%Q{DISTINCT stores.id,stores.name,stores.url}).
      #where(["name ILIKE ? AND sales.city_id=?","#{params[:q]}%",@user.city_id]).
      where(["(name ILIKE ?) OR (name ILIKE ?)","#{params[:q]}%", params[:q]]).
      joins(%Q{INNER JOIN "sales" on "sales"."store_id"="stores"."id"}).
      limit(20)

    @sales = Sale.where(["(brand_id IN (?)) OR (store_id IN (?))",
                          @brands.collect(&:id),
                          @stores.collect(&:id)]).
      where(:visible => true).
      select(%Q{"sales".*, "faves"."id" as my_fave_id}).
      joins(%Q{LEFT OUTER JOIN "faves" ON "faves"."sale_id"="sales"."id" 
               AND "faves"."user_id"=#{@user.id}}).
      includes(:user).
      order(%Q{"sales"."created_at" DESC}).
      limit(10).
      offset(params[:offset]).all

    puts "q: #{params[:q]} " + @sales.collect(&:id).join(",")
  end

  def index_all(limit = 10)
    @sales = all_sales.
      limit(limit).
      offset(params[:offset]).all
  end

  def all_sales
    where_conditions = {
      :visible => true
    }

    where_frag = nil

    if params[:category_id]
      where_conditions.update({:category_id => params[:category_id]})
    end
    if params[:size] and not params[:size].empty?
      where_frag = ["? = ANY (sales.sizes)",params[:size]]
    end
    if params[:city_id] and not params[:city_id].empty?
      where_conditions.update({:city_id => params[:city_id]})
    end

    curated_sales = Sale.where(where_conditions.merge({
       :editors_pick => true})).
      where(where_frag).
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
      where(where_frag).
      select(curated_select).
      joins(%Q{LEFT OUTER JOIN "faves" ON "faves"."sale_id"="sales"."id" 
               AND "faves"."user_id"=#{@user.id}}).
      includes(:user).
      order(curated_order)
  end

end
