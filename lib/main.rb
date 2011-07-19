require_relative "views/welcome_menu"
require_relative "data/product_handler"
require_relative "data/order_handler"
require_relative "data/products/boat"
require_relative "data/products/diving_gear"
require_relative "data/products/jet_ski"
require_relative "data/products/surfboard"

#Main file for launching the program. Does basic setup for the program.
puts "Starting up..."

#Creating selection
boat_names = ["Liberty", "Victory", "Seahorse", "Silver Lining", "Serenity", "Sea Ya", "Sea Spirit",
              "Misty", "Wind Dancer", "Destiny", "Tide Runner", "Sundancer"]
12.times{ |i| ProductHandler.add_to_selection(Boat, Boat.new(boat_names[i])) }
5.times { |i| ProductHandler.add_to_selection(DivingGear, DivingGear.new(i+1)) }
3.times { |i| ProductHandler.add_to_selection(JetSki, JetSki.new(i+1)) }
15.times{ |i| ProductHandler.add_to_selection(Surfboard, Surfboard.new(i+1)) }

#Rents three random products
3.times{OrderHandler::rent}

#Enables messaging
$MESSAGES_ON = true

#Shows first menu
WelcomeMenu::show