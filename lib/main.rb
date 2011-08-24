require_relative "views/welcome_menu"
require_relative "data/product_handler"
require_relative "data/order_handler"
require_relative "data/products/boat"
require_relative "data/products/diving_gear"
require_relative "data/products/jet_ski"
require_relative "data/products/surfboard"
require_relative "data/database_handler"

#Main file for launching the program. Does basic setup for the program.
puts "Starting up..."

#Sets up the database
DatabaseHandler::init

#Enables messaging
$MESSAGES_ON = true

#Shows first menu
WelcomeMenu::show