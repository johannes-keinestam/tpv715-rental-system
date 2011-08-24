require_relative "products/boat"
require_relative "products/diving_gear"
require_relative "products/jet_ski"
require_relative "products/surfboard"

#Module which handles the selection of the store (i.e. the hash of products).
module ProductHandler
  #Structure: { product_category => [Array of articles] }
  @selection = Hash.new

  #Returns the selection of the store. Some menus use this information.
  def ProductHandler.get_selection
    return @selection
  end

  #Returns the product with the given id number.
  def ProductHandler.get_product(id)
    matches = @selection.values.flatten.select { |product| product.id == id }
    return matches[0]
  end
  
  #Adds a product to the specified product category of the selection. Used when
  #creating the selection at startup.
  def ProductHandler.add_to_selection(category, product_name, product_id = nil)
    unless @selection.has_key?(category)
      @selection[category] = Array.new
    end
    if product_id.nil?
      product_id = rand(1000)
      while @selection.values.flatten.include?(product_id)
        product_id = rand(1000)
      end
    end
    product = category.new(product_name, product_id)
    @selection[category].push(product)
  end

  #Convenience method for setting prices for a product category.
  def ProductHandler.set_price(category, b_price, h_price, d_price)
    #gets the product category with the given name
    product_class = eval(category)

    #sets prices
    product_class.price_base = b_price unless b_price.nil?
    product_class.price_hr = h_price unless h_price.nil?
    product_class.price_day = d_price unless d_price.nil?
  end
end
