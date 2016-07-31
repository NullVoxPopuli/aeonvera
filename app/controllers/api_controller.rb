class APIController < ActionController::Base
  include CommonApplicationController
  respond_to :json
  before_action :set_default_response_format
  protect_from_forgery with: :null_session

  skip_before_filter :verify_authenticity_token

  # used by ember - over https in production, clear text otherwise
  before_filter :authenticate_user_from_token!
  before_action :set_time_zone

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  protected

  def render_model(include_param = nil, success_status: 200)
    render_json_response(
      include_param,
      success_status,
      ->(model) { model.errors.present? })
  end

  def render_models(include_param = nil, success_status: 200)
    render_json_response(
      include_param,
      success_status,
      ->(model) { model.respond_to?(:errors) && model.errors.present? })
  end

  def render_json_response(include_param, success_status = 200, error_condition = nil)
    raise ActiveRecord::RecordNotFound if model.nil?

    if error_condition && error_condition.call(model)
      render json: model, status: 422, serializer: ActiveModel::Serializer::ErrorSerializer
    else
      render json: model, include: include_param, status: success_status
    end
  end

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

  def not_found(id_key = nil)
    id = params[:id]
    id = params[id_key] || params[:id] if id_key
    render json: {
        jsonapi: { version: '1.0' },
        errors: [
          {
            id: id,
            code: 404,
            title: 'not-found',
            detail: "Resource not found",
            meta: {
              params: params
            }
          }
        ]
      }, status: 404
  end

  def set_default_response_format
    request.format = :json unless params[:format]
  end
end
