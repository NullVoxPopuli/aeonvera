# frozen_string_literal: true

module Api
  class SponsorshipSerializer < ActiveModel::Serializer
    PUBLIC_ATTRIBUTES = [:id].freeze
    PUBLIC_RELATIONSHIPS = [:sponsor, :sponsored, :discount].freeze
    PUBLIC_FIELDS = Array[*PUBLIC_ATTRIBUTES, *PUBLIC_RELATIONSHIPS]

    attributes(PUBLIC_ATTRIBUTES)

    belongs_to :sponsor
    belongs_to :sponsored
    belongs_to :discount
  end
end
