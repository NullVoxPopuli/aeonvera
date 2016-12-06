# frozen_string_literal: true
module Api
  module NoteOperations
    class ParentOverride < SkinnyControllers::Operation::Default
      include HelperOperations::Helpers

      def parent
        @parent ||= host_from_params(params_for_action)
      end

      # See: https://github.com/NullVoxPopuli/skinny_controllers/issues/31
      def model_params
        params_for_action
      end
    end

    class ReadAll < ParentOverride
      def run
        query = params[:q]
        query[:target_type_eq] = 'User' if query && query[:target_type_eq] == 'Member'

        @model = parent.notes.ransack(query).result
        check_allowed!
        @model
      end
    end
    class Read < ParentOverride; end
    class Create < ParentOverride
      def run
        target_type = params_for_action[:target_type]
        params_for_action[:target_type] = User.name if target_type == 'Member'
        @model = parent.notes.build(params_for_action)
        @model.author = current_user

        check_allowed!

        @model.save
        @model
      end
    end
    class Update < ParentOverride; end
    class Delete < ParentOverride; end
  end
end
