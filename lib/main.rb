require_relative "views/welcome_menu"
require_relative "data/data_container"
require_relative "data/boat"
require_relative "data/diving_gear"
require_relative "data/jet_ski"
require_relative "data/surfboard"

#Main file for launching the program. Does basic setup for the program.
puts "Starting up..."

#Creating selection
12.times{ |i| DataContainer.add_to_selection("Boat", Boat.new(i+1)) }
5.times { |i| DataContainer.add_to_selection("Diving Gear", DivingGear.new(i+1)) }
3.times { |i| DataContainer.add_to_selection("Jet Ski", JetSki.new(i+1)) }
15.times { |i| DataContainer.add_to_selection("Surfboard", Surfboard.new(i+1)) }

#Rents three random products
3.times{DataContainer::rent}

#Enables messaging
$MESSAGES_ON = true

#Shows first menu
WelcomeMenu::show