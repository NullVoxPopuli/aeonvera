# frozen_string_literal: true
module Api
  module RestraintOperations
    # expected params
    # - restriction_for_id
    # - restriction_for_type
    # - restricted_to_id
    # - restricted_to_type
    class Create < SkinnyControllers::Operation::Base
      def run
        create
      end

      def create
        @model = restraint = build_from_params
        return restraint unless restraint.valid?

        restraint.save if allowed?
        restraint
      end

      def build_from_params
        restriction_for_id, restriction_for_type = params_for_action
                                                   .values_at(:restriction_for_id, :restriction_for_type)

        restricted_to_id, restricted_to_type = params_for_action
                                               .values_at(:restricted_to_id, :restricted_to_type)

        # fix the types
        # ember sends them over in plural lower case
        restricted_to_type = restricted_to_type.singularize.camelize if restricted_to_type
        restriction_for_type = restriction_for_type.singularize.camelize if restriction_for_type

        Restraint.new(
          dependable_id: restriction_for_id,
          dependable_type: restriction_for_type,
          restrictable_id: restricted_to_id,
          restrictable_type: restricted_to_type
        )
      end
    end

    class Update < SkinnyControllers::Operation::Base
      def run
        update
      end

      def update
        update_from_params
        return model unless model.valid?

        model.save if allowed?
        model
      end

      def update_from_params
        restricted_to_id, restricted_to_type = params_for_action
                                               .values_at(:restricted_to_id, :restricted_to_type)

        # fix the types
        # ember sends them over in plural lower case
        restricted_to_type = restricted_to_type.singularize.camelize if restricted_to_type

        model.update(
          restrictable_id: restricted_to_id,
          restrictable_type: restricted_to_type
        )
      end
    end
  end
end
