class String
	def to_b
		# http://jeffgardner.org/2011/08/04/rails-string-to-boolean-method/
		return true if self == true || self =~ (/(true|t|yes|on|y|1)$/i)
		return false if self == false || self.nil? || self =~ (/(false|f|no|off|n|0)$/i)
		raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
	end

end
