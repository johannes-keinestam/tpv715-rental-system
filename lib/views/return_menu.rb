require_relative "welcome_menu"
require_relative "messenger"
require_relative "../data/order_handler"

#Menu which lets a user return their rented products.
module ReturnMenu
  #Shows the return menu in the console, containing the list of all rented products.
  def ReturnMenu.show
    system "cls"

    #Gets all active order, and puts in array.
    @orders = (OrderHandler::get_orders).select { |order| order.is_active? }

    puts "============================================================"
    puts "Current rentals:"
    @orders.each_index {|x| puts "    #{x+1}. #{@orders.at(x)}"}
    puts "    None" if @orders.empty?
    puts "    0. Cancel"
    puts "============================================================"
    puts "Which rental do you want to return?"

    get_choice
  end

  #Gets a choice (which product to return) from user. Returns order if valid choice.
  def ReturnMenu.get_choice
    choice = gets.to_i

    #If valid number tried to be deleted, return to welcome menu, otherwise show again
    if choice != 0 and choice <= @orders.length
      returned_order = @orders[choice-1]
      Messenger::show_message("#{returned_order.product} returned!\nRented: #{returned_order.start_time}\nReturned: #{Time.now}\nPrice: $#{returned_order.get_price}")
      OrderHandler::return(returned_order)
    elsif choice == 0
      WelcomeMenu::show
    else
      Messenger::show_error("Not valid menu choice")
    end
    self.show
  end
end
