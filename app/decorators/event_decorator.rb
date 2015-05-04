class EventDecorator < Draper::Decorator

	# only get recent attendees once
	def recent_attendees
		@recent_attendees ||= object.attendances.limit(5).order("created_at DESC")
	end

	def total_leads
		@total_leads ||= object.attendances.leads.count
	end

	def total_follows
		@total_follows ||= object.attendances.follows.count
	end

	def total_registrants
		@total_registrants ||= object.attendances.count
	end

	def revenue
		@revenue ||= object.revenue || 0
	end

	def unpaid
		@unpaid ||= object.unpaid_total || 0
	end

end
