class SearchResultsController < ApplicationController
  before_filter :handle_device
  before_filter :require_user, :except => :index
  before_filter :get_cart
  before_filter :view_cart
  #before_filter :use_search_results

  def index
    if params[:q].nil? or params[:q].empty?
      render :json => [].to_json
      return
    end

    @brands = Brand.select(%Q{DISTINCT brands.id,brands.name}).
      #where(["name ILIKE ? AND sales.city_id=?","#{params[:q]}%",@user.city_id]).
      where(["name ILIKE ?","#{params[:q]}%"]).
      joins(%Q{INNER JOIN "sales" on "sales"."brand_id"="brands"."id"}).
      limit(20)

    @stores = Store.select(%Q{DISTINCT stores.id,stores.name,stores.url}).
      #where(["name ILIKE ? AND sales.city_id=?","#{params[:q]}%",@user.city_id]).
      where(["name ILIKE ?","#{params[:q]}%"]).
      joins(%Q{INNER JOIN "sales" on "sales"."store_id"="stores"."id"}).
      limit(20)

    respond_to do |wants|
      wants.json { index_json }
      wants.html { index_html }
    end
  end

  def index_html
    @sales = Sale.where(["(brand_id IN (?)) OR (store_id IN (?))",
      @brands.collect(&:id),
      @stores.collect(&:id)]).
      where(:visible => true).
#      select(%Q{"sales".*, "faves"."id" as my_fave_id}).
#      joins(%Q{LEFT OUTER JOIN "faves" ON "faves"."sale_id"="sales"."id" 
#               AND "faves"."user_id"=#{@user.id}}).
#      includes(:user).
      order(%Q{"sales"."created_at" DESC}).
      page(params[:page]).
      per(8)
  end

  def index_json
    @results = (@brands + @stores).sort_by do |x| 
      1.0 - x.name.downcase.levenshtein_similar(params[:q].downcase)
    end[0..19]

    @results_hashed = @results.collect do |result|
      if result.kind_of?(Brand)
        {:brand_id => result.id,
         :brand_name => result.name}
      else
        {:store_id => result.id,
         :store_name => result.name,
         :store_url => result.url}
      end
    end

    render :json => @results_hashed.to_json    
  end


end
