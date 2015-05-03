class UserParameterSanitizer < Devise::ParameterSanitizer
  def sign_in
    default_params.permit(:username, :email)
  end

  def sign_up
  	default_params.permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

  def account_update
    default_params.permit(
    	:first_name, :last_name,
    	:email, :password, :password_confirmation, :current_password,
    	:time_zone
    )
  end
end
