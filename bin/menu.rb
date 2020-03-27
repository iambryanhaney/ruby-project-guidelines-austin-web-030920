

class Menu
    attr_accessor :links, :previous_menu, :data

   # @@nodes = {}
    @@current = nil
    @@user = nil

    def initialize(key)
        @links = {}
        #self.class.nodes[key] = self
        menu_object = self
        self.class.define_singleton_method(key) { menu_object }
    end






    def self.nodes
        @@nodes
    end

    def self.current
        @@current
    end

    def self.current=(menu_next)
        @@current = menu_next
    end

    def self.user
        @@user
    end

    def self.user=(user)
        @@user = user
    end




    def self.start_menu
        Menu.current = Menu.home
        while(Menu.current) do
            Menu.current.action
        end
    end




    def self.clear
        system("clear") || system("cls")
    end

    def self.print_menu(header, items, back = true, exit = true)
        print "\n\n\t\t[#{header}]\n\n"
        items.each{|item| print "#{item}\n"}
        print "\n--------\n\n"
        print "9. Back\n" if back
        print "0. Exit\n\n> "
    end

    def self.print_prompt(header, body)
        print "\n\n\t\t[#{header}]\n\n#{body}"
    end

    def self.print_header(header)
        print "\n\n\t\t[#{header}]\n\n"
    end

    def self.getch
        user_input = STDIN.getch.to_i
        while (user_input != 0) && !Menu.current.links[user_input]
            user_input = STDIN.getch.to_i
        end
        user_input
    end

    def self.anykey
        STDIN.getch
    end
end


# All .action methods take an argument, do some work, and output a hash containing a :menu object and an :argument hash

Menu.new(:home)
Menu.new(:login)
Menu.new(:create_user)
Menu.new(:main)
Menu.new(:search_by_performer)
Menu.new(:sbp_event_list)
Menu.new(:sbp_event_spotlight)
Menu.new(:search_by_venue)
Menu.new(:search_by_type)
Menu.new(:event_info)
Menu.new(:my_tickets)
Menu.new(:mt_event_spotlight)
Menu.new(:exit)




# Menu.home
Menu.home.links = {1 => Menu.login, 2 => Menu.create_user}
Menu.home.define_singleton_method(:action) do
    Menu.user = nil
    Menu.clear
    Catpix::print_image("./images/seatgeek.jpg", limit_x: 0.5)
    Menu.print_menu "Home", ["1. Log into existing account", "2. Create new account"], false
    user_input = Menu.getch
    Menu.current = @links[user_input]
end


# Menu.login
Menu.login.define_singleton_method(:action) do
    Menu.clear
    Menu.print_header("Home -> Login")
    print "Enter username: "
    user_name = gets.chomp
    print "Enter password: "
    user_pass = gets.chomp
    Menu.user = User.find_by(name: user_name, password: user_pass)
    if Menu.user
        print "\nWelcome back to SeatGeek, #{user_name}! Press any key to begin...\n\n"
        Menu.anykey
        Menu.current = Menu.main
    else
        print "\nInvalid username or password. Press any key to continue...\n\n"
        Menu.anykey
        Menu.current = Menu.home
    end
end


# Menu.create_user
Menu.create_user.define_singleton_method(:action) do
    Menu.clear
    Menu.print_header("Home -> Create Account")
    print "Username: "
    user_name = gets.chomp
    if User.find_by(name: user_name)
        print "\nThat username is already taken. Press any key to continue...\n\n"
        Menu.anykey
        Menu.current = Menu.home
    else
        print "Enter password: "
        user_pass = gets.chomp
        Menu.user = User.create(name: user_name, password: user_pass)
        print "\nWelcome to SeatGeek, #{user_name}! Press any key to begin...\n\n"
        Menu.anykey
        Menu.current = Menu.main    
    end
end


# Menu.main
Menu.main.links = {1 => Menu.search_by_performer, 2 => Menu.search_by_venue, 3 => Menu.search_by_type, 4 => Menu.my_tickets, 9 => Menu.home}
Menu.main.define_singleton_method(:action) do
    Menu.clear
    Menu.print_menu "Main Menu", ["1. Search by Performer", "2. Search by venue", "3. Search by event name", "4. My tickets"]
    user_input = Menu.getch
    Menu.current = @links[user_input]
end


# Menu.search_by_performer
Menu.search_by_performer.define_singleton_method(:action) do
    Menu.clear
    Menu.print_header("Main Menu -> Search By Performer")
    print "Enter a performer name: "
    user_input = gets.chomp
    events = SeatGeek.search_by_performer(user_input).first(5)
    if events.empty?
        print "\nI'm sorry, no events were found for #{user_input}. Press any key to continue...\n\n"
        Menu.anykey
        Menu.current = Menu.main
    else
        Menu.current = Menu.sbp_event_list
        Menu.current.data = events
    end
end


# Menu.sbp_event_list
Menu.sbp_event_list.define_singleton_method(:action) do
    # menu_sbp_event_list.links = {1 => menu_sbp_event_spotlight}
    Menu.clear
    Menu.print_header("Main Menu -> Search By Performer -> Events")
    
    @data.each_with_index do |event, index|
        puts "#{index+1}. #{event["title"]}"
    end

    print "\n--------\n\n9. Back\n0. Exit\n\n> "
    user_input = STDIN.getch.to_i

    case user_input
    when 1..(@data.length)
        Menu.current = Menu.sbp_event_spotlight
        Menu.current.data = @data[user_input-1]
    when 9
        Menu.current = Menu.main
    when 0
        Menu.current = Menu.exit
    end
    
end


# Menu: sbp_event_spotlight
Menu.sbp_event_spotlight.define_singleton_method(:action) do
    Menu.clear
    Menu.print_header("Main Menu -> Search By Performer -> Events -> Event Spotlight")

    title = @data["title"]
    price = @data["stats"]["average_price"]
    date = @data["datetime_local"].split("T")[0]
    time = @data["datetime_local"].split("T")[1]
    url = @data["url"]
    image_url = @data["performers"][0]["image"]

    Down.download(image_url, destination: "./images/event_image.jpg")
    Catpix::print_image("./images/event_image.jpg", limit_x: 0.5)
    
    puts "\n\nTitle: #{title}"
    puts "Price: #{price}"
    puts "Date:  #{date}"
    puts "Time:  #{time}"
    puts "URL:   #{url}\n\n"

    print "1. Buy ticket\n2. Open URL in Browser\n\n-----\n\n9. Back\n0. Exit\n\n> "

    user_input = STDIN.getch.to_i

    case user_input
    when 1
        event = Event.find_or_create_by(title: title, price: price, date: date, time: time, url: url, image_url: image_url)
        Menu.user.events << event
        puts "\nTicket purchased! Press any key to continue...\n\n"
        Menu.anykey
    when 2
        system("open", url)
        puts "\nOpening URL in browser. Pres any key to continue...\n\n"
        Menu.anykey
    when 9
        Menu.current = Menu.sbp_event_list
    when 0
        Menu.current = Menu.exit
    end
end


# Menu.my_tickets
Menu.my_tickets.define_singleton_method(:action) do
    Menu.clear
    Menu.print_header("Main Menu -> My Tickets")
    
    # events = Menu.user.events.first(8)
    # events.each_with_index do |event, index|
    #     puts "#{index+1}. #{event["title"]}"
    # end

    tickets = Menu.user.tickets.first(8)
    tickets.each_with_index do |ticket, index|
        puts "#{index+1}. #{ticket.event["title"]}"
    end

    print "\n--------\n\n9. Back\n0. Exit\n\n> "
    user_input = STDIN.getch.to_i

    case user_input
    when 1..(tickets.length)
        Menu.current = Menu.mt_event_spotlight
        Menu.current.data = tickets[user_input-1].event
    when 9
        Menu.current = Menu.main
    when 0
        Menu.current = Menu.exit
    end
end


# Menu.mt_event_spotlight
Menu.mt_event_spotlight.define_singleton_method(:action) do
    Menu.clear
    Menu.print_header("Main Menu -> My Tickets -> Event Spotlight")

    Down.download(@data[:image_url], destination: "./images/event_image.jpg")
    Catpix::print_image("./images/event_image.jpg", limit_x: 0.5)
    
    puts "\n\nTitle: #{@data[:title]}"
    puts "Price: #{@data[:price]}"
    puts "Date:  #{@data[:date]}"
    puts "Time:  #{@data[:time]}"
    puts "URL:   #{@data[:url]}\n\n"
  
    puts "\nPress any key to return to your tickets...\n\n"
    Menu.anykey
    Menu.current = Menu.my_tickets
end


# Menu.exit
Menu.exit.define_singleton_method(:action) do
    Menu.clear
    Menu.print_header("Exit")

    print "Thank you for using SeatGeek, #{Menu.user[:name]}! Press any key to exit.\n\n"
    Menu.anykey

    Menu.current = nil
end




# # Menu: search_by_type
# menu_search_by_type.links = {0 => menu_main}
# def menu_search_by_type.action
#     print "Which event?\n\n> "
#     user_input = gets.chomp
#     #API calls
#     puts "We searched by type using user_input: #{user_input}!\n"
#     self.links[0]
# end


# # Menu: search_by_venue
# menu_search_by_venue.links = {0 => menu_main}
# def menu_search_by_venue.action
#     puts "Which venue?\n"
#     user_input = gets.chomp
#     # events = bryans_api_venue_call(user_input)
#     # titles = events.map{|event| event["title"]}
#     puts "We searched by venue using user_input: #{user_input}!"
#     self.links[0]
# end


# # Menu: event_info
# menu_event_info.links = {0 => menu_main}
# def menu_event_info.action
#     puts "Would you like to buy tickets?\n"
#     user_input = gets.chomp
#     #API calls here with event info
#     self.links[0]
# end