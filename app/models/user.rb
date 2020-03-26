
class User < ActiveRecord::Base
    has_many :tickets
    has_many :events, through: :tickets

    def buy_ticket(event_hash)
        event = Event.find_or_create_by(title: event_hash["title"], price: event_hash["stats"]["average_price"])
        self.events << event
    end

    def my_tickets
        self.events.map{|event| {title: event.title, price: event.price}}
    end
    
end