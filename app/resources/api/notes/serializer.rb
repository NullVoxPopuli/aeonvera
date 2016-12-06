# frozen_string_literal: true
module Api
  class NoteSerializer < ActiveModel::Serializer
    type 'notes'

    attributes :id, :note, :author_name

    belongs_to :host
    # TODO: what if the target isn't a user
    belongs_to :target, serializer: MemberSerializer

    def author_name
      object.author.name
    end
  end
end
