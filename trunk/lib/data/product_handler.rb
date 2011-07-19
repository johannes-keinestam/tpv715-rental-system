#Module which handles the selection of the store (i.e. the hash of products).
module ProductHandler
  #Structure: { product_category => [Array of articles] }
  @selection = Hash.new

  #Returns the selection of the store. Some menus use this information.
  def ProductHandler.get_selection
    return @selection
  end

  #Adds a product to the specified product category of the selection. Used when
  #creating the selection at startup.
  def ProductHandler.add_to_selection(category, product)
    unless @selection.has_key?(category)
      @selection[category] = Array.new
    end
    @selection[category].push(product)
  end
end
