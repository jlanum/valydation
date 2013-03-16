class SaleGroupsController < ApplicationController
  before_filter :handle_user

  def landing
    @page = Page.find_by_slug("curated-landing")

  end

end
