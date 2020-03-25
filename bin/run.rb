require_relative '../config/environment'



uri = URI.parse("https://api.seatgeek.com/2/events?client_id=MjExNDI3ODR8MTU4NTE2MzM2OS43")
response = Net::HTTP.get_response(uri)
random_var_name = JSON.parse(response.body)

def clear
    (system "clear") || system("cls")
end

#user log in
clear 
puts "Welcome to project_name\n1. New User\n2. Login\n\n>"
response = gets.chomp

#main menu
clear
puts "What would you like to do?\n"
puts "1. Search events by event title"
puts "2. Search events by performer"
puts "3. Search events by venue"
puts "4. TBD"
puts "5. Quit\n"

input = gets.chomp
    