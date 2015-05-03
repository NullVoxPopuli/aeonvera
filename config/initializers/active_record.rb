class ActiveRecord::Base

	def has_errors?
		self.errors.size > 0
	end

	# Thread safe approach to disabling timestamp updates.
	# Useful when we need to modify data without altering updated_at.
	# http://blog.bigbinary.com/2009/01/21/override-automatic-timestamp-in-activerecord-rails.html
	def save_without_timestamping
		class << self
			def record_timestamps; false; end
		end

		save!

		class << self
			remove_method :record_timestamps
		end
	end
end
