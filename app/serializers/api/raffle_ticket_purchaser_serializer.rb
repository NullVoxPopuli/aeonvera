module Api
  # the objects for this is built in raffle#ticket_purchase_data
  class RaffleTicketPurchaserSerializer < ActiveModel::Serializer
    attributes :id, :attendance_id, :name, :number_of_tickets_purchased

    def id
      object.attendance_id
    end

    def attendance_id
      object.attendance_id
    end

    def name
      object.name
    end

    def number_of_tickets_purchased
      object.number_of_tickets_purchased
    end
  end
end
