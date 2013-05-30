class Cart 
attr_reader :items
attr_accessor :current_user
attr_accessor :image_upload_urls
 

  
  def initialize
      @items = []
    end

    def add_to_cart(sale_id) 
      @items << sale_id
      end
      
      def clear
        @items.clear
      end
      
      
      
      
  end
