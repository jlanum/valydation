class PagesController < ApplicationController
  before_filter :handle_user

  def show
    @page = Page.where(:slug => params[:slug]).first
    @title = @page.title unless @page.title.to_s.empty?
    if @page
      if @page.slug == "landing"
        use_layout = false
      elsif @user
        use_layout = "application"
      else
        use_layout = "prelogin"
      end
      render :layout => use_layout
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

end
