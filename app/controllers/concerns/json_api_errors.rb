# frozen_string_literal: true
module JsonApiErrors
  extend ActiveSupport::Concern

  protected

  def must_be_logged_in
    return if current_user

    render json: {
      jsonapi: { version: '1.0' },
      errors: [
        {
          code: 401,
          title: 'Unauthorized'
        }
      ]
    }, status: 401

    # halt the action chain
    false
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
          detail: 'Resource not found',
          meta: {
            params: params
          }
        }
      ]
    }, status: 404
  end
end
