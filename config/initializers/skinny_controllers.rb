# frozen_string_literal: true
# SkinnyControllers.controller_namespace = 'Api'

module SkinnyControllers
  module Operation
    module ModelHelpers
      def model_from_named_id(key, id)
        name = key.gsub(/_id$/, '')
        name = name.camelize
        model_from_scope(
          id: id,
          type: name
        ).ransack(params[:q]).result
        # only this last line was added for searching with ransack
      end
    end
  end
end
