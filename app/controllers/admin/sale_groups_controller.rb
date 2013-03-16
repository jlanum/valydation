class Admin::SaleGroupsController < ApplicationController
  before_filter :admin_auth

  layout "admin"

  def index
    @groups = SaleGroup.page(params[:page]).
      per(50).
      order("created_at DESC")
  end

  def create
    @group = SaleGroup.new
    @group.update_attributes(params[:group])
    @group.save!
    
    @message = "The group has been updated."
  
    render :template => "admin/sale_groups/edit"
  end

  def update
    @group = SaleGroup.find(params[:id])
    @group.update_attributes(params[:group])
    @group.save!
    
    @message = "The group has been updated."
  
    render :template => "admin/sale_groups/edit"
  end

  def edit
    @group = SaleGroup.find(params[:id])
  end

  def new
    @group = SaleGroup.new
    render :template => "admin/sale_groups/edit"    
  end

  def destroy
    @group = SaleGroup.find(params[:id])
    @group.destroy

    flash[:message] = "The group has been deleted"
    redirect_to admin_sale_groups_url
  end
end
