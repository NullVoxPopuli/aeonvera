class AdminSubdomain
	def self.matches?(request)
		(request.subdomain.present? and request.subdomain =~ /#{APPLICATION_CONFIG["admin_subdomain"]}/)
	end
end
