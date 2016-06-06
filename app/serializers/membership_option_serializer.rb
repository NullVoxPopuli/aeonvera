class MembershipOptionSerializer < ActiveModel::Serializer
  include PublicAttributes::LineItemAttributes
  type 'membership-options'

  attributes :duration_in_words
end
