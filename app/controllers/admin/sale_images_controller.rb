class Admin::SaleImagesController < ApplicationController

  def new
    image_index = params[:image].to_i
    @sale = Sale.find(params[:sale_id])
    @sale.send("temp_image_url_#{image_index}=",params[:key])
    @sale.uploaded_images = true
    @sale.processed_images = false
    @sale.save!

    redirect_to edit_admin_sale_url(@sale, 
      :message => "Image #{image_index} has been uploaded to S3. It will take about a minute before it's visible.")
  end

  def destroy
    @sale = Sale.find(params[:sale_id])
    image_index = params[:id].to_i
    @sale.send("temp_image_url_#{image_index}=",nil)
    @sale.send("remove_image_#{image_index}!")
    @sale.save!

    redirect_to edit_admin_sale_url(@sale, 
      :message => "Image #{image_index} has been removed!")
  end

end
