class ApplicationController < ActionController::Base
  include CommonApplicationController

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token
  before_action :set_time_zone

  protected

  def devise_parameter_sanitizer
    if resource_class == User
      UserParameterSanitizer.new(User, :user, params)
    else
      super
    end
  end

  private

  # overrides devise hook
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end

  # overrides devise hook
  def after_sign_up_path_for(resource)
    stored_location_for(resource) || root_path
  end

  # overrides devise hook
  def after_sign_out_path_for(resource)
    root_url
  end

end
