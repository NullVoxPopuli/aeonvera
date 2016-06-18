class SponsorshipSerializer < ActiveModel::Serializer
  attributes :id, :discount_amount

  belongs_to :sponsor
  belongs_to :sponsored
end
