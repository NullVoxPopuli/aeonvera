class SessionsController < Devise::SessionsController
  protect_from_forgery with: :null_session
  skip_before_filter :verify_authenticity_token
  skip_before_filter :verify_signed_out_user

  respond_to :html, :json

  def create
    super do |user|
      if request.format.json?
        data = {
          token: user.authentication_token,
          email: user.email
        }
        render json: data, status: 201 and return
      end
    end
  end
end
