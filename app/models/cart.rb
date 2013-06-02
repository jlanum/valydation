class Cart 
  attr_reader :items
  attr_accessor :current_user, :sale_id, :user_id, :item_id
  attr_accessor :image_upload_urls


  def initialize
    @items = []
  end

  def add_to_cart(sale) 
    unless @items.find { |i| i.id == sale.id }
      @items << sale
    end
    @items
  end

  def remove_from_cart(sale)
    @items.delete_if { |i| i.id == sale.id }
  end

  def clear
    @items.clear
  end

end
