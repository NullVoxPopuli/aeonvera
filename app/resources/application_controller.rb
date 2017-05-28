# frozen_string_literal: true
class ApplicationController < ActionController::Base
  include CommonApplicationController

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token
  before_action :set_time_zone

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
  def after_sign_out_path_for(_resource)
    root_url
  end
end
