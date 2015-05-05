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

	def pricing_tiers_in_order
		# opening tier should be first
		opening_tier = object.opening_tier
		# pricing tiers should already be sorted by
		# - registrants ASC
		# - date ASC
		tiers = object.pricing_tiers.to_a.keep_if{ |t| t.id != opening_tier.id }
		tiers = [opening_tier] + tiers
		tiers
	end

end
