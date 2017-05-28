# frozen_string_literal: true
module Controllers
  module DeviseOverrides
    # overrides devise's respond_with
    def respond_with(obj, *_args)
      if obj.respond_to?(:errors) && obj.errors.present?
        render json: obj, status: 422, serializer: ActiveModel::Serializer::ErrorSerializer
      else
        render json: obj
      end
    end

    def respond_with_navigational(*args)
      respond_with(*args)
    end
  end
end
