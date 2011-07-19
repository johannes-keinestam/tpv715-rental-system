require_relative "../views/welcome_menu"
require_relative "../views/messenger"
require_relative "order_handler"
require_relative "product_handler"

#Module for queuing customers who, at the time of their order, couldn't rent their
#product because they were already in use.
module QueueSystem
  #Structured: { product_category => [Array of customers] }
  @queue = Hash.new

  #Puts a customer in queue for a given type of product
  def QueueSystem.queue(product, customer)
    #If the product category doesn't exist, create it.
    unless @queue.has_key?(product)
      @queue[product] = Array.new
    end
    #Puts customer in queue, and messages him
    @queue[product].push(customer)
    Messenger::show_message("Sorry #{customer}, no #{product} is available right now.\nYou have been placed in our queue, and will be informed when a #{product} is available!")
  end

  #Checks if any requested products are available, and rents them to the first
  #customer in the queue.
  def QueueSystem.check_availability
    #Only picks the product categories which are in the queue
    selection = ProductHandler::get_selection
    queued_categories = selection.select { |category,articles| @queue.has_key?(category) }

    #Restructures the selection to: { product_category => number_of_available_products }
    available_product_count = Hash.new
    queued_categories.each { |category,articles| available_product_count[category] = articles.count { |article| not article.is_rented? } }

    #Try to rent out each available product from the list. Then deletes customer
    #from queue, so the next on in the queue gets the next available product and so on.
    available_product_count.each do |category,available_products|
      available_products.times do
        unless @queue[category].empty?
          OrderHandler::rent(category, @queue[category].first)
          @queue[category].shift
        end
      end
    end
  end
  
end
