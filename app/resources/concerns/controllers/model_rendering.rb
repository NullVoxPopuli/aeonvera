# frozen_string_literal: true

module Controllers
  module ModelRendering
    extend ActiveSupport::Concern

    DEFAULT_OK_OPTIONS = { status: :ok }.freeze
    DEFAULT_ERROR_OPTIONS = { status: :unprocessable_entity }.freeze

    included do
      class << self
        attr_accessor :serializer
      end
    end

    protected

    def success(resource, options = {})
      success_renderer.render(resource, options)
    end

    def success_renderer
      @success_renderer ||= JSONAPI::Serializable::SuccessRenderer.new
    end

    def error_renderer
      @error_renderer ||= JSONAPI::Serializable::ErrorRenderer.new
    end

    def render_jsonapi_model(model, options: {}, succeeded: nil)
      succeeded ||= model.respond_to?(:errors) ? model.errors.blank? : succeeded

      if succeeded
        render_jsonapi(
          model,
          DEFAULT_OK_OPTIONS.merge(options)
        )
      else
        render(
          DEFAULT_ERROR_OPTIONS
            .merge(options)
            .merge(json: model.errors)
        )
      end
    end

    def render_jsonapi(model, options)
      render({ json: model }.merge(options))
    end

    def render_model(include_param = nil, success_status: 200, jsonapi: false)
      render_json_response(
        include_param,
        success_status,
        ->(model) { model.errors.present? },
        jsonapi: jsonapi
      )
    end

    def render_models(include_param = nil, success_status: 200, jsonapi: false)
      render_json_response(
        include_param,
        success_status,
        ->(model) { model.respond_to?(:errors) && model.errors.present? },
        jsonapi: jsonapi
      )
    end

    def render_json_response(include_param, success_status = 200, error_condition = nil, jsonapi: false)
      raise ActiveRecord::RecordNotFound if model.nil?

      return render_jsonapi_error(model) if error_present?(error_condition, model)

      if jsonapi
        render_options = {
          fields: params[:fields] || {},
          include: include_param
        }

        render_options[:class] = self.class.serializer if self.class.serializer

        return render(
          status: success_status,
          json: success(model, render_options)
        )
      end

      options = {
        jsonapi: model,
        include: include_param,
        fields: params[:fields] || {},
        status: success_status
      }

      if self.class.serializer
        if model.respond_to?(:each)
          options[:each_serializer] = self.class.serializer
        else
          options[:serializer] = self.class.serializer
        end
      end

      render(options)
    end

    private

    def error_present?(condition, model)
      condition && condition.call(model)
    end

    def render_jsonapi_error(model)
      render json: model, status: 422, serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end
end
