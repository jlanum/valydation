class ErrorsController < ApplicationController

  def not_found
    render :template => "errors/404", :layout => "prelogin"
  end

end
