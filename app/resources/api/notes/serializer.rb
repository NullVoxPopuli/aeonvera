# frozen_string_literal: true
module Api
  class NoteSerializer < ActiveModel::Serializer
    type 'notes'

    attributes :id, :note

    belongs_to :host
    belongs_to :author
    # TODO: what if the target isn't a user
    belongs_to :target, serializer: MemberSerializer
  end
end
