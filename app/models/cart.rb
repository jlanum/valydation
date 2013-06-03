class Cart 
  attr_reader :items

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

  def as_json
    {:items => @items.collect { |item| { :sale_id => item.id } }}
  end

  def to_json
    as_json.to_json
  end

  def self.from_json(json)
    hash = JSON.parse(json)
    cart = Cart.new
    hash['items'].each do |item_hash|
      if sale = Sale.where(:id => item_hash['sale_id']).first
        cart.add_to_cart(sale)
      end
    end
    cart
  end

end
