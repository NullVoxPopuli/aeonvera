class AdminController < ActionController::Base

	before_filter :check_admin_subdomain
	before_filter :current_user
	helper_method :admin_subdomain?, :current_domain
	layout "admin"

	protected

	# Retrieve the current user by checking _admin_token
	# and verify that a user exists with that openid.
	# Otherwise, redirect to /auth/admin which starts the
	# Google Apps OpenID sequence.
	# @see Admin::Sessions#authenticate
	# @see Admin::Sessions#failure
	def current_user
		return true if Rails.env.test?
    
		if cookies['_admin_token'].present?
			uid = Base64.decode64(cookies['_admin_token'])
			user = Admin::User.find_by_uid(uid)
			if user.nil?
				cookies.delete('_admin_token')
			else
				return user
			end
		else
			return redirect_to '/auth/admin'
		end

	end

	# Since the default, catch-all routes at the bottom of routes.rb
	# allow the admin controllers to be accessed via any subdomain,
	# this before_filter prevents that kind of access, rendering
	# (by default) a 404.
	def check_admin_subdomain
		raise ActionController::RoutingError, "Not Found" unless admin_subdomain?
	end


	def admin_subdomain?
		request.subdomains.first == APPLICATION_CONFIG['admin_subdomain']
	end

	def current_domain
		APPLICATION_CONFIG[:domain][Rails.env]
	end
end
