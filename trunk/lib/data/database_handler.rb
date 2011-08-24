require "sqlite3"
require_relative "order_handler"
require_relative "product_handler"

#Module which acts as an intermediary between the database and the rest of the
#application. Also handles creation of the database if it doesn't exist.
module DatabaseHandler
  #Uses SQLite3 and sqlite3-ruby gem
  include SQLite3

  #Loads database from file.
  def DatabaseHandler.init
    db_path = File.expand_path(File.dirname(File.dirname(__FILE__)))+"/data.db"
    db_exists = File.file?(db_path)
    @db = Database.new(db_path)

    #if the database doesn't exist, creates it.
    unless db_exists
      @db.execute("CREATE TABLE customers (id INT, name VARCHAR(50), address VARCHAR(75), card_no CHAR(20));")
      @db.execute("CREATE TABLE selection (category VARCHAR(50), name VARCHAR(50), id INT);")
      @db.execute("CREATE TABLE orders (product_id INT, customer_id INT, start_time INT, end_time INT, price INT);")
      @db.execute("CREATE TABLE prices (category VARCHAR(50), base_price INT, hourly_price INT, daily_price INT);")
      populate_database
    end

    #loads data from database into application. ORDER IS IMPORTANT!
    load_selection
    load_prices
    load_customers
    load_orders
  end

  #Inserts default values into database tables. For use when creating the database.
  def DatabaseHandler.populate_database
    #creates selection
    boat_names = ["Liberty", "Victory", "Seahorse", "Silver Lining", "Serenity", "Sea Ya", "Sea Spirit",
              "Misty", "Wind Dancer", "Destiny", "Tide Runner", "Sundancer"]
    12.times{ |i| @db.execute("INSERT INTO selection (category, name, id) values ('Boat', 'Boat: #{boat_names[i]}', #{i})") }
    5.times { |i| @db.execute("INSERT INTO selection (category, name, id) values ('DivingGear', 'Diving Gear kit #{i+1}', #{i+12})") }
    3.times { |i| @db.execute("INSERT INTO selection (category, name, id) values ('JetSki', 'Jet Ski #{i+1}', #{i+17})") }
    15.times{ |i| @db.execute("INSERT INTO selection (category, name, id) values ('Surfboard', 'Surfboard #{i+1}', #{i+20})") }

    #creates price list
    @db.execute("INSERT INTO prices (category, base_price, hourly_price, daily_price) values ('Boat', 200, 100, 1200)")
    @db.execute("INSERT INTO prices (category, base_price, hourly_price, daily_price) values ('DivingGear', 25, 50, 400)")
    @db.execute("INSERT INTO prices (category, base_price, hourly_price, daily_price) values ('JetSki', 50, 70, 700)")
    @db.execute("INSERT INTO prices (category, base_price, hourly_price, daily_price) values ('Surfboard', 15, 10, 100)")

    #rents three random products by three random customers
    random_products = Array.new
    3.times { |i| random_products[i] = rand(35) }
    duplicates = random_products.uniq!
    while (not duplicates.nil?) && (not random_products.size == 3)
      random_products.push(rand(35))
      duplicates = random_products.uniq!
    end
    3.times { |i| @db.execute("INSERT INTO customers (id, name, address, card_no) values (#{i}, 'Customer #{i+1}', '123 Main Street, 90210 CA', '0000-0000-0000-0000')") }
    3.times { |i| @db.execute("INSERT INTO orders (product_id, customer_id, start_time) values (#{random_products[i]}, #{i}, #{Time.now.to_i})") }
  end

  #Loads all products from database to application.
  def DatabaseHandler.load_selection
    database_selection = @db.execute("SELECT * FROM selection")
    database_selection.each do |product_row|
      product_class = eval(product_row[0])
      ProductHandler::add_to_selection(product_class, product_row[1], product_row[2])
    end
  end

  #Loads all customers from database to application.
  def DatabaseHandler.load_customers
    database_customers = @db.execute("SELECT * FROM customers")
    database_customers.each do |customer_row|
      OrderHandler::create_customer(*customer_row)
    end
  end

  #Loads all orders from database to application.
  def DatabaseHandler.load_orders
    database_orders = @db.execute("SELECT * FROM orders")
    database_orders.each do |customer_row|
      OrderHandler::create_order(*customer_row)
    end
  end

  #Loads all prices from database to application.
  def DatabaseHandler.load_prices
    database_prices = @db.execute("SELECT * FROM prices")
    database_prices.each do |price_row|
      ProductHandler::set_price(*price_row)
    end
  end

  #Returns the database associated to the program. Only used by SaveMenu, which
  #practically just dumps the database to a text file.
  def DatabaseHandler.get_database
    return @db
  end

  #Creates a new database post for a customer object.
  def DatabaseHandler.save_customer(customer)
    @db.execute("INSERT INTO customers (id, name, address, card_no) values (#{customer.id}, '#{customer.name}', '#{customer.address}', '#{customer.card_no}')")
  end

  #Creates a new order post for an order object.
  def DatabaseHandler.save_order(order)
    if order.stop_time.nil?
      @db.execute("INSERT INTO orders (product_id, customer_id, start_time) values (#{order.product.id}, #{order.customer.id}, #{order.start_time.to_i})")
    else
      @db.execute("INSERT INTO orders (product_id, customer_id, start_time, end_time, price) values (#{order.id}, #{order.customer.id}, #{order.start_time.to_i}, #{order.stop_time.to_i}, #{order.price});")
    end
  end

  #Updates existing order's end time and price.
  def DatabaseHandler.update_order(order)
    @db.execute("UPDATE orders SET end_time = #{order.stop_time.to_i}, price = #{order.get_price} WHERE product_id = #{order.product.id} AND customer_id = #{order.customer.id} AND start_time = #{order.start_time.to_i}")
  end

  #Updates the prices for a given product category.
  def DatabaseHandler.update_prices(category, b_price, h_price, d_price)
    @db.execute("UPDATE prices SET base_price = #{b_price}, hourly_price = #{h_price}, daily_price = #{d_price} WHERE category = '#{category.to_s}'")
  end
end
