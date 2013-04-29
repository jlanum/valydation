



def process_sales
  Sale.where(:uploaded_images => true,
             :processed_images => false).each do |sale|
    sale.process_images!
    sale.visible = false
    sale.save!
  end
end



