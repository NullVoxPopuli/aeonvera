# frozen_string_literal: true
class APIController < ActionController::Base
  include CommonApplicationController
  include JsonApiErrors
  include ModelRendering

  respond_to :json

  before_action :set_default_response_format

  protect_from_forgery with: :null_session

  skip_before_filter :verify_authenticity_token

  # used by ember - over https in production, clear text otherwise
  before_filter :authenticate_user_from_token!
  before_action :set_time_zone

  rescue_from StandardError, with: :server_error
  rescue_from ActionController::RoutingError, with: :routing_error
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  # TODO: Change this to a 401 (instead of 404)
  rescue_from SkinnyControllers::DeniedByPolicy, with: :not_found

  def error_route
    # JSONAPI formatted routing error
    raise ActionController::RoutingError.new(params[:path])
  end

  protected

  def deserialize_params(polymorphic: [], embedded: [])
    ActiveModelSerializers::Deserialization
      .jsonapi_parse(params, embedded: embedded, polymorphic: polymorphic)
  end

  # wrapper around normal strong parameters that includes Deserialization
  # for JSON API parameters.
  # all parameters hitting this controller should be JSON API formatted.
  #
  # example:
  # whitelistable_params do |whitelister|
  #   whitelister.permit(:name, :price)
  # end
  def whitelistable_params(polymorphic: [], embedded: [])
    deserialized = deserialize_params(
      polymorphic: polymorphic,
      embedded: embedded
    )

    whitelister = ActionController::Parameters.new(deserialized)
    whitelister = yield(whitelister) if block_given?

    EmberTypeInflector.to_rails(whitelister)
  end

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
end
