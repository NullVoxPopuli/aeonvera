class APIController < ActionController::Base
  include CommonApplicationController
  protect_from_forgery with: :null_session

  # TODO: Check HTTPS. If not HTTPS, reject all API Requests
  skip_before_filter :verify_authenticity_token

  before_filter :check_subdomain
  # used by ember - over https in production, clear text otherwise
  before_filter :authenticate_user_from_token!
  # regular auth method
  # before_filter :authenticate_user!, except: [:sign_in, :assume_control]

  before_action :set_time_zone

  before_action :subdomain_failure?

  helper_method :current_domain

end
