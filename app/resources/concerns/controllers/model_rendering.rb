# frozen_string_literal: true

module Controllers
  module ModelRendering
    extend ActiveSupport::Concern

    DEFAULT_OK_OPTIONS = { status: :ok }.freeze
    DEFAULT_ERROR_OPTIONS = { status: :unprocessable_entity }.freeze

    included do
      class << self
        attr_accessor :serializer
        attr_accessor :default_fields
        attr_accessor :default_include
      end
    end

    protected

    def render_jsonapi(options: {}, model: nil)
      model ||= self.model

      raise ActiveRecord::RecordNotFound if model.nil?
      return render_jsonapi_error(model) if errors_present?(model)

      default_exposed = { current_user: current_user }
      exposed = default_exposed.merge(options.delete(:expose) || {})

      jsonapi_options = {
        expose: exposed,
        fields: options.delete(:fields) || allowed_fields,
        include: options.delete(:include) || allowed_include,
        class: options.delete(:class) || serializer
      }

      render_options = DEFAULT_OK_OPTIONS
                       .merge(options)
                       .merge(json: success(model, jsonapi_options))

      render(render_options)
    end

    def success(resource, options = {})
      success_renderer.render(resource, options)
    end

    def success_renderer
      @success_renderer ||= JSONAPI::Serializable::SuccessRenderer.new
    end

    def error_renderer
      @error_renderer ||= JSONAPI::Serializable::ErrorsRenderer.new
    end

    def default_fields
      self.class.default_fields
    end

    def default_include
      self.class.default_include
    end

    def allowed_include
      params[:include] || default_include || {}
    end

    def allowed_fields
      params[:fields] || default_fields || {}
    end

    private

    def errors_present?(model)
      model.respond_to?(:errors) && model.errors.present?
    end

    def render_jsonapi_error(model)
      errors = model.errors.messages.map { |k, v|
        JSONAPI::Serializable::Error.create(detail: v.first, source: "data/attributes/#{k}")
      }

      render json: error_renderer.render(errors), status: 422
    end

    def serializer
      self.class.serializer
    end
  end
end
