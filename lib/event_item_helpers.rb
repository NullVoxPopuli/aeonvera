module EventItemHelpers
	def has_packages?
		self.packages.size > 0
	end

	def has_levels?
		self.levels.size > 0
	end

	def has_line_items?
		self.order_line_items.count > 0
	end

	def has_competitions?
		self.competitions.size > 0
	end

	def has_shirts?; self.shirts.count > 0;	end

	def has_discounts?
		self.discounts.size > 0
	end
end
