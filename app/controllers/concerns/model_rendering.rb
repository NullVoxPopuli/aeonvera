# frozen_string_literal: true
module ModelRendering
  extend ActiveSupport::Concern

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
end
