 class APIController < ActionController::Base
  include CommonApplicationController

  respond_to :json
  protect_from_forgery with: :null_session

  skip_before_filter :verify_authenticity_token

  # used by ember - over https in production, clear text otherwise
  before_filter :authenticate_user_from_token!
  before_action :set_time_zone

  protected

  def render_model(include_param = nil)
    if model.errors.present?
      render json: model.errors.to_json_api, status: 422
    else
      render json: model, include: include_param
    end
  end

  def must_be_logged_in
    unless current_user
      render json: {
          jsonapi: { version: '1.0' },
          errors: [
            {
              code: 401,
              title: 'Unauthorized'
            }
          ]
        }, status: 401
      return false
    end
  end
end
