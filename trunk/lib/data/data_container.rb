require_relative "boat"
require_relative "article"
require_relative "order"
require_relative "customer"
require_relative "queue_system"

#Module which constitutes the main "backend" of the program. Keeps track of placed
#orders and the selection in the shop. 
module DataContainer
  #Structure: { product_category => [Array of articles] }
  @selection = Hash.new
  #Structure: { customer => [Array of placed orders] }
  @customers = Hash.new

  #Rents a random product of the given product category (String) to the specified
  #customer. If no product category given, it rents a completely random product
  #(for use at application start up). If invalid category, no rental is made.
  #Automatically places customer in queue if the product wanted isn't available.
  def DataContainer.rent(product=nil, customer=nil)
    if product == nil
      rent_random
    elsif @selection.has_key?(product)
      available_products = @selection[product].select { |article| not article.is_rented? }
      unless available_products.empty?
        #product is available, renting random in category
        chosen_product = available_products[rand(available_products.length)]
        #add customer if he doesn't exist, otherwise just place order
        unless @customers.has_key?(customer)
          @customers[customer] = Array.new
        end
        placed_order = Order.new(chosen_product, customer)
        placed_order.set_active(true)
        @customers[customer].push(placed_order)
        Messenger::show_message("#{customer}, you are now renting #{chosen_product}!")
      else
        #no products in category available, queues customer
        QueueSystem::queue(product, customer)
      end
    end
  end

  #Returns an order. Does nothing if order isn't active (i.e. already returned).
  #When an order is returned, the queue system checks if any queued customer's
  #requested product(s) have become available.
  def DataContainer.return(order)
    if (order.product.is_rented?)
      order.set_active(false)
      QueueSystem::check_availability
    end
  end

  #Random product rented with a generated customer. For use at startup.
  def DataContainer.rent_random
    random_customer = Customer.new("Customer #{rand(10)}", "0000-0000-0000-0000", "123 Main Street, 90210 CA")
    random_product = @selection.keys[rand(@selection.keys.length)]
    rent(random_product, random_customer)
  end

  #Returns the selection of the store. Some menus use this information.
  def DataContainer.get_selection
    return @selection
  end

  #Returns all placed orders (active as well as inactive). Some menus use this
  #information.
  def DataContainer.get_orders
    return @customers
  end

  #Adds a product to the specified product category of the selection. Used when
  #creating the selection at startup.
  def DataContainer.add_to_selection(category, product)
    unless @selection.has_key?(category)
      @selection[category] = Array.new
    end
    @selection[category].push(product)
  end
  
  #Returns the customer of the given name
  def DataContainer.get_customer(name)
    name_matches = @customers.keys.select { |customer| customer.to_s == name }
    return name_matches[0]
  end
end

