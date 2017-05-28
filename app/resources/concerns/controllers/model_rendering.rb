# frozen_string_literal: true
module Controllers
  module ModelRendering
    extend ActiveSupport::Concern

    included do
      class << self
        attr_accessor :serializer
      end
    end

    protected

    def render_model(include_param = nil, success_status: 200)
      render_json_response(
        include_param,
        success_status,
        ->(model) { model.errors.present? }
      )
    end

    def render_models(include_param = nil, success_status: 200)
      render_json_response(
        include_param,
        success_status,
        ->(model) { model.respond_to?(:errors) && model.errors.present? }
      )
    end

    def render_json_response(include_param, success_status = 200, error_condition = nil)
      raise ActiveRecord::RecordNotFound if model.nil?

      if error_condition && error_condition.call(model)
        render json: model, status: 422, serializer: ActiveModel::Serializer::ErrorSerializer
      else
        options = {
          json: model,
          include: include_param,
          status: success_status
        }

        if self.class.serializer
          if model.respond_to?(:each)
            options[:each_serializer] = self.class.serializer
          else
            options[:serializer] = self.class.serializer
          end
        end

        render options
      end
    end
  end
end
