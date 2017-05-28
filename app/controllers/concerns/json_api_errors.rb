# frozen_string_literal: true
module JsonApiErrors
  extend ActiveSupport::Concern

  protected

  def must_be_logged_in
    return true if current_user

    jsonapi_error(401, code: 401,
                       title: 'Unauthorized')

    # halt the action chain
    false
  end

  def not_found(id_key = nil)
    id = params[:id]
    id = params[id_key] || params[:id] if id_key

    jsonapi_error(404,
      id: id,
      code: 404,
      title: 'not-found',
      detail: 'Resource not found',
      meta: {
        params: params
      })

    false
  end

  def server_error(exception)
    jsonapi_error(500,
      code: 500,
      detail: exception.message,
      title: 'The backend responded with an error',
      meta: {
        backtrace: exception.backtrace
      })
  end

  def routing_error(exception)
    jsonapi_error(404,
      code: 404,
      detail: exception.message,
      title: 'Route Not Found',
      meta: {
        backtrace: exception.backtrace
      })
  end

  def client_error(exception)
    jsonapi_error(400,
      code: 400,
      detail: exception.message,
      title: 'Client Error',
      meta: {
        backtrace: exception.backtrace
      })
  end

  def jsonapi_error(status, errors)
    errors = errors.is_a?(Hash) ? [errors] : errors

    render json: {
      jsonapi: { version: '1.0' },
      errors: errors
    }, status: status
  end
end
