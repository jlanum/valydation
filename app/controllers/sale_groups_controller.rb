class SaleGroupsController < ApplicationController
  before_filter :handle_user
  before_filter :get_cart
  before_filter :view_cart

end
