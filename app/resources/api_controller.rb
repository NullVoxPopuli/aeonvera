# frozen_string_literal: true
class APIController < ActionController::Base
  include Controllers::CurrentUser
  include Controllers::JsonApiErrors
  include Controllers::ModelRendering
  include Controllers::StrongParameters
  include Controllers::ErrorHandlers

  respond_to :json

  before_action :set_default_response_format

  protect_from_forgery with: :null_session

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

  def sync_form_and_model(form, model)
    form.sync

    form_errors = form.errors.messages
    return if form_errors.blank?

    form_errors.each do |field, errors|
      Array[*errors].each do |error|
        model.errors.add(field, error)
      end
    end
  end

  def set_time_zone
    return unless current_user && current_user.time_zone.present?
    Time.zone = current_user.time_zone
  end
end
