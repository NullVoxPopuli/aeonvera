class RaffleSerializer < ActiveModel::Serializer

  attributes :id, :name, :winner, :winner_has_been_chosen

  belongs_to :event
  has_many :raffle_tickets

  def winner
    if object.winner.present?
      object.winner.attendee_name
    end
  end

  def winner_has_been_chosen
    object.winner.present?
  end

end
