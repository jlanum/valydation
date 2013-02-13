class Admin::PagesController < ApplicationController
  http_basic_authenticate_with :name => "admin", :password => "Green1994"
  
  layout "admin"

  def index
    @pages = Page.order("slug ASC").all
  end  

  def edit
    @page = Page.find(params[:id])
  end

  def update
    @page = Page.find(params[:id])
    @page.content = params[:page][:content]
    @page.title = params[:page][:title]
    @page.save!
    
    @message = "The page has been updated."
  
    render :template => "admin/pages/edit"
  end
end
