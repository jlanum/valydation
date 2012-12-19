class DevicesController < ApplicationController
  before_filter :handle_device

  def create
    if @device
      @device.apns_token = params[:apns_token]
      @device.save!
    elsif @duid
      Device.create!(:duid => @duid, :apns_token => params[:apns_token])
    else
      raise "WTF, no duid."
    end

    render :json => @device.to_json
  end
end
