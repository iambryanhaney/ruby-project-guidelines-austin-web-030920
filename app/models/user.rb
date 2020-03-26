

class User < ActiveRecord::Base
    has_many :tickets
    has_many :events, through: :tickets

    # def initialize(username, password)

    # end

    def buy_ticket(event)
        Ticket.create(self, event)
    end
end