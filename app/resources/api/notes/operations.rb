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
        @model = parent.notes
        check_allowed!
        @model
      end
    end
    class Read < ParentOverride; end
    class Create < ParentOverride
      def run
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
