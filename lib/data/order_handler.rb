require_relative "order"
require_relative "customer"
require_relative "queue_system"
require_relative "product_handler"
require_relative "products/article"
require_relative "../views/messenger"

#Module which handles customers and orders.
module OrderHandler
  #Structure: { customer => [Array of placed orders] }
  @customers = Hash.new

  #Rents a random product of the given product category to the specified
  #customer. If no product category given, it rents a completely random product
  #(for use at application start up). If invalid category, no rental is made.
  #Automatically places customer in queue if the wanted product isn't available.
  def OrderHandler.rent(product=nil, customer=nil)
    selection = ProductHandler::get_selection
    if product == nil
      rent_random
    elsif selection.has_key?(product)
      available_products = selection[product].select { |article| not article.is_rented? }
      unless available_products.empty?
        #product is available, renting random in category
        chosen_product = available_products[rand(available_products.length)]
        #add customer if he doesn't exist, otherwise just place order
        unless @customers.has_key?(customer)
          @customers[customer] = Array.new
          DatabaseHandler::save_customer(customer)
        end
        placed_order = Order.new(chosen_product, customer)
        placed_order.set_active(true)
        @customers[customer].push(placed_order)
        DatabaseHandler::save_order(placed_order)
        Messenger::show_message("#{customer}, you are now renting #{chosen_product}!")
      else
        #no products in category available, queues customer
        QueueSystem::queue(product, customer)
      end
    end
  end

  #Random product rented with a generated customer. For use at startup.
  def OrderHandler.rent_random
    random_customer = Customer.new("Customer #{rand(10)}", "0000-0000-0000-0000", "123 Main Street, 90210 CA", get_available_customer_id)
    selection = ProductHandler::get_selection
    random_product = selection.keys[rand(selection.keys.length)]
    rent(random_product, random_customer)
  end

  #Returns an order. Does nothing if order isn't active (i.e. already returned).
  #When an order is returned, the queue system checks if any queued customer's
  #requested product(s) have become available.
  def OrderHandler.return(order)
    if (order.product.is_rented?)
      order.set_active(false)
      DatabaseHandler::update_order(order)
      QueueSystem::check_availability
    end
    
  end

  #Creates an order with the specified information. Used when loading database.
  def OrderHandler.create_order(product, customer, start_time, end_time, price)
    #gets the specified product object
    product = ProductHandler::get_product(product) unless product.is_a?(Article)
    #gets the specified customer object (by id)
    customer = get_customer(customer)

    #converts time format used for database storage to Time object.
    start_t = Time.at(start_time)
    end_t = Time.at(end_time) rescue end_t = nil

    #creates order, and updates it's information according to database.
    order = Order.new(product, customer)
    order.set_active(true) if end_t.nil?
    order.start_time = start_t
    order.stop_time = end_t
    order.price = price

    #adds customer/order information to hash
    if customer.nil?
      @customers[customer] = Array.new
    end
    @customers[customer].push(order)
  end

  #Creates a new customer with specified information. Used when loading database
  #into program.
  def OrderHandler.create_customer(id, name, address, card_no)
    customer = Customer.new(name, card_no, address, id)
    @customers[customer] = Array.new
  end

  #Returns an available, randomized customer id number.
  def OrderHandler.get_available_customer_id
    customer_id = rand(1000)
    while @customers.keys.flatten.include?(customer_id)
      customer_id = rand(1000)
    end
    return customer_id
  end
  
  #Returns all placed orders (active as well as inactive). Some menus use this
  #information.
  def OrderHandler.get_customer_orders
    return @customers
  end

  #Returns all orders in an array.
  def OrderHandler.get_orders
    return @customers.values.flatten
  end

  #Returns all customers in an array.
  def OrderHandler.get_customers
    return @customers.keys.flatten
  end

  #Returns the customer of the given name
  def OrderHandler.get_customer(identifier)
    if identifier.is_a?(Integer)
      #identifier is a number, interprets as customer id number.
      id_matches = @customers.keys.flatten.select { |customer| customer.id == identifier }
      return id_matches[0]
    else
      #identifier is something else, interprets as customer name.
      name_matches = @customers.keys.flatten.select { |customer| customer.to_s == identifier }
      return name_matches[0]
    end
  end
  
end
