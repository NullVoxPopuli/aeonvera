# frozen_string_literal: true
module Api
  class RestraintSerializer < ActiveModel::Serializer
    type 'restraints'

    belongs_to :restriction_for
    belongs_to :restricted_to

    def restricted_to
      object.restrictable
    end

    def restriction_for
      object.dependable
    end
  end
end
