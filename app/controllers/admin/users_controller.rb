class Admin::UsersController < AdminController

	def index
		@users = User.all
	end

	# generate a temporary token to login with
	# sorta similar to a password reset token
	# the token is stored in redis with an expiration
	def assume_control
		token = SecureRandom.hex

		user = ::User.find(params[:id])

		# expire in 10 seconds
		Cache.set(token, user.id)
		Cache.expire(token, 10)

		redirect_to("//#{current_domain}/users/#{token}/assume_control")
	end

end
