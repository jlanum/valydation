class CitiesController < ApplicationController

  def index
    @cities = City.all

    render :json => @cities.to_json
  end
end
