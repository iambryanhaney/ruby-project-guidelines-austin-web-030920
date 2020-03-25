require_relative '../config/environment'



uri = URI.parse("https://api.seatgeek.com/2/events?client_id=MjExNDI3ODR8MTU4NTE2MzM2OS43")
response = Net::HTTP.get_response(uri)
random_var_name = JSON.parse(response.body)
binding.pry
