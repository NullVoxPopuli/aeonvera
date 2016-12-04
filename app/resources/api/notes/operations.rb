# frozen_string_literal: true
module Api
  module NoteOperations
    class ParentOverride < SkinnyControllers::Operation::Default
      include HelperOperations::Helpers

      # TODO make getting the parent configurable from
      #      the controller
      def find_model
        host = host_from_params(params)
        relation = host.notes

        params[:id] ? relation.find(params[:id]) : relation
      end
    end

    class ReadAll < ParentOverride; end
    class Create < ParentOverride; end
    class Read < ParentOverride; end
    class Update < ParentOverride; end
    class Delete < ParentOverride; end
  end
end
