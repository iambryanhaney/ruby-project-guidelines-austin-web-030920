


class SeatGeek
    CLIENT_ID = "MjExNDI3ODR8MTU4NTE2MzM2OS43"

    def self.search_by_performer(performer)
        slug = performer.split(" ").join("-")
        self.query("events?performers.slug=#{slug}&client_id=#{CLIENT_ID}")["events"]
    end

    def self.search_by_venue(venue)

    end

    def self.search_by_taxonomies(taxonomies)
        "?taxonomies.name=" + "Monster Trucks, Sports, Magic".split(",").map{|str| str.split(" ")}.map{|array| array.join("_")}.join("&taxonomies.name=")
    end

    def self.query(qstring)
        uri = URI.parse('https://api.seatgeek.com/2/' + qstring)
        response = Net::HTTP.get_response(uri)
        JSON.parse(response.body)
    end
    
end
