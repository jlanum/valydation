class Cart 
attr_reader :items

  def initialize
      @items = []
    end

    def add_to_cart(sale) 
      @items << sale
      end
      
      def clear
        @items.clear
      end
  end
