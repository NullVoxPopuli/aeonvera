class Pass < ActiveRecord::Base
	belongs_to :event
	belongs_to :attendance

	belongs_to :discountable, polymorphic: true



	def discount_for
		self.discountable.try(:name)
	end

	def attendee_name
		self.attendance.attendee_name if self.attendance
	end
end
