class Raffle < ActiveRecord::Base
  include SoftDeletable
	belongs_to :event
	has_many :raffle_tickets,
		class_name: "LineItem::RaffleTicket",
		foreign_key: "reference_id"
	has_many :tickets,
		class_name: "LineItem::RaffleTicket",
		foreign_key: "reference_id"
	belongs_to :winner,
		class_name: "Attendance"


	def choose_winner
		build_participant_weights.sample
	end

	def ticket_holders
		self.event.attendances.participating_in_raffle(self.id)
	end

	private

	# it's ok to return a array with objects in it, because we
	# are not going to store the result of this
	#
	# @return [Array<Attendance]
	def build_participant_weights
		result = []
		ticket_holders.each do |ticket_holder|
			tickets_for_ticket_holder(ticket_holder).times do |ticket|
				result << ticket_holder
			end
		end
		result
	end

	# @param [Attendance] ticket_holder
	def tickets_for_ticket_holder(ticket_holder)
		ticket_holder.raffle_tickets.map(&:number_of_tickets).inject(:+)
	end

end
