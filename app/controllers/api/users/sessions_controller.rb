class Api::Users::SessionsController < Devise::SessionsController
  clear_respond_to
  respond_to :json

  prepend_before_filter :require_no_authentication, only: [:create]

  # We have to write our own login, cause devise isn't
  # designed for API Authentication
  #
  # instead of returning the current user,
  # we want to return the auth token.
  # the auth token and email will be passed on every request,
  # and the user will be authorized based on the validitity
  # of the token and email pair.
  #
  # HTTPS required :-)
  def create
    resource = User.find_by_email(params[:user][:email])
    return invalid_login_attempt unless resource

    success = resource.valid_password?(params[:user][:password])

    if success
      sign_in("user", resource)
      return render_success(resource)
    end

    invalid_login_attempt
  end

  def destroy
    sign_out(resource_name)
  end

  protected

  def invalid_login_attempt
    # have to declare custom failure,
    # cause warden likes to redirect
    warden.custom_failure!

    render json: {
      error: I18n.t('devise.failure.not_found_in_database')
    }, status: 401
  end

  def render_success(user)
    data = {
       token: user.authentication_token,
       email: user.email,
       id: user.id
     }
     render json: data, status: 201
  end
end
