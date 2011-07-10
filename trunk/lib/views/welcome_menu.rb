require_relative "rent_menu"
require_relative "return_menu"
require_relative "listings_menu"
require_relative "financial_menu"

#Menu shown at startup, which presents the structure of the program.
module WelcomeMenu
  #Shows the welcome menu in the console.
  def WelcomeMenu.show
    #Clears screen, might not work cross-platform
    system "cls"

    puts "============================================================"
    puts "Welcome to the Ruby Beach Water Sports rental system \n\n"
    puts "Menu:"
    puts "    1. Rent"
    puts "    2. Return"
    puts "    3. Listings"
    puts "    4. Financials"
    puts "    0. Exit"
    puts "============================================================"
    puts "What do you want to do?"
         
    get_choice
  end

  #Gets the user's choice (of which submenu to display).
  def WelcomeMenu.get_choice
    choice = gets.chomp

    #Handles the input from the user. Easily extendable for later.
    case choice
      when "1" then RentMenu::show
      when "2" then ReturnMenu::show
      when "3" then ListingsMenu::show
      when "4" then FinancialMenu::show
      when "0" then Process.exit
      else WelcomeMenu.show
    end
  end
end
