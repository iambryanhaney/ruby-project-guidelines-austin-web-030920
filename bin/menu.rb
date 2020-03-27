

puts "\n\n...greetings from the MENU!\n\n"

class Menu
    attr_accessor :text, :links

    @@home = nil

    def display
        puts @text
    end

    def clear
        (system "clear") || system("cls")
    end




    def self.home
        @@home
    end

    def self.home=(menu_object)
        @@home = menu_object
    end


    def self.start_menu
        menu_current = self.home
        while(menu_current.class != String) do
            menu_current.display
            user_input = gets.chomp
            menu_current = menu_current.action(user_input)
            menu_current.clear
        end
    end

end


# All .action methods take a user_input, do some work, and output a menu object
menu_main = Menu.new
menu_search_by_performer = Menu.new
menu_search_by_venue = Menu.new
menu_search_by_type = Menu.new
menu_event_info = Menu.new
menu_view_tickets = Menu.new
menu_login = Menu.new
menu_create_user = Menu.new
menu_home = Menu.new

# Menu: home
menu_home.text = "Home\n\n1. Log into existing user\n2. Create new user"
menu_home.links = {1 => menu_login, 2 => menu_create_user}
def menu_home.action(user_input)
    @links[user_input.to_i]
end

# Menu: login
menu_login.text = "Login\n\nEnter username:"
menu_login.links = {0 => menu_main}
def menu_login.action(user_input)
    #AR user stuff
    @links[0]
end

# Menu: create user
menu_create_user.text = "Create user\n\n User:"
menu_create_user.links = {0 => menu_main}
def menu_create_user.action(user_input)
    #AR storing new info
    @links[0]
end

# Menu: main
menu_main.text = "Main Menu\n\n1. Search by Performer\n2. Search by venue\n3. Search by event name\n4. View tickets\n5. Quit"
menu_main.links = {1 => menu_search_by_performer, 2 => menu_search_by_venue, 3 => menu_search_by_type, 4 => menu_view_tickets, 5 => "Quit"}
def menu_main.action(user_input)
    # filter user input
    # return self if input is out of range
    # return the links[user_input] object if input is in range
    @links[user_input.to_i]
end

# Menu: view tickets
menu_view_tickets.text = " "
menu_view_tickets.links = {0 => menu_main}
def menu_view_tickets.action(user_input)
    # events = user.my_tickets
    # events.each_with_index do |event, i| puts "#{i}. #{event[:title]}    Price: #{event[:price]}\n"
    self.links[0]
end

# Menu: search by type
menu_search_by_type.text = "Which event?"
menu_search_by_type.links = {0 => menu_main}
def menu_search_by_type.action(user_input)
    #API calls
    puts "We searched by type using user_input: #{user_input}!"
    self.links[0]
end



# Menu: search_by_performer
menu_search_by_performer.text = "Which performer?"
menu_search_by_performer.links = {0 => menu_main}
def menu_search_by_performer.action(user_input)
    # events = bryans_api_performer_call(user_input)
    # titles = events.map{|event| event["title"]}
    puts "We searched by performer using user_input: #{user_input}!"
    self.links[0]
end

# Menu: search_by_venue
menu_search_by_venue.text = "Which venue?"
menu_search_by_venue.links = {0 => menu_main}
def menu_search_by_venue.action(user_input)
    # events = bryans_api_venue_call(user_input)
    # titles = events.map{|event| event["title"]}
    puts "We searched by venue using user_input: #{user_input}!"
    self.links[0]
end

# Menu: event_info
menu_event_info.text = "Would you like to buy tickets?"
menu_event_info.links = {0 => menu_main}
def menu_event_info.action(user_input)
    #API calls here with event info
    self.links[0]
end

Menu.home = menu_home
