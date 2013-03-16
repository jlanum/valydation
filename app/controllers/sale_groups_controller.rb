class SaleGroupsController < ApplicationController
  before_filter :handle_user

  def landing
    @page = Page.find_by_slug("curated-landing")
    @groups = SaleGroup.where(:featured => true).
      order("updated_at DESC").
      limit(4).all
  end

end
