class SaleGroupsController < ApplicationController
  before_filter :handle_user

  def landing
    if @user
      redirect_to sales_url
      return
    end

    @page = Page.find_by_slug("curated-landing")
    @groups = SaleGroup.where(:featured => true).
      order("updated_at DESC").
      limit(4).all
  end

end
