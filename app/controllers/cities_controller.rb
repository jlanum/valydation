class CitiesController < ApplicationController

  def index
    @cities = City.order("name ASC").all

    render :json => @cities.to_json
  end
end
