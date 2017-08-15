# frozen_string_literal: true

module Api
  class NotesController < Api::ResourceController
    self.serializer = NoteSerializableResource

    before_action :must_be_logged_in

    private

    def create_note_params
      whitelistable_params(polymorphic: [:target, :host]) do |whitelister|
        whitelister.permit(
          :note,
          :target_id, :target_type,
          :host_id, :host_type
        )
      end
    end

    def update_note_params
      whitelistable_params do |whitelister|
        whitelister.permit(:note)
      end
    end

    def index_note_params
      params.require(:host_id)
      params.require(:host_type)
      params
    end
  end
end
