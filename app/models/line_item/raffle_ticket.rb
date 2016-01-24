class LineItem::RaffleTicket < LineItem
	belongs_to :raffle, foreign_key: :reference_id

	has_many :purchasers,
		through: :attendance_line_items,
		source: :attendance

	def number_of_tickets
		self.metadata["number_of_tickets"]
	end

	def number_of_tickets=(tickets)
		self.metadata["number_of_tickets"] = tickets
	end
end
