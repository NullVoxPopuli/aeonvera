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

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from SkinnyControllers::DeniedByPolicy, with: :not_found

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
end
