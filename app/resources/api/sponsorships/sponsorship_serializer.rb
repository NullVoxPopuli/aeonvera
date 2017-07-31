# frozen_string_literal: true
module Api
  class SponsorshipSerializer < ActiveModel::Serializer
    attributes :id

    belongs_to :sponsor
    belongs_to :sponsored
    belongs_to :discount
  end
end
