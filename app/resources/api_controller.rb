# frozen_string_literal: true
class APIController < ActionController::Base
  include Controllers::CurrentUser
  include Controllers::JsonApiErrors
  include Controllers::ModelRendering
  include Controllers::StrongParameters
  include Controllers::ErrorHandlers

  respond_to :json
  protect_from_forgery with: :null_session

  before_action :set_default_response_format
  skip_before_filter :verify_authenticity_token

  # used by ember - over https in production, clear text otherwise
  before_filter :authenticate_user_from_token!
  before_action :set_time_zone

  def error_route
    # JSONAPI formatted routing error
    raise ActionController::RoutingError, params[:path]
  end

  protected

  def set_default_response_format
    request.format = :json unless params[:format]
  end

  def set_time_zone
    return unless current_user && current_user.time_zone.present?
    Time.zone = current_user.time_zone
  end

  def self.merged_fieldset(source, hash)
    keys = hash.keys
    fields = source.dup
    fields.delete_if { |k, _v| keys.include?(k) }

    fields.push(hash)
    fields
  end
end
