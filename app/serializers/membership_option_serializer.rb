class MembershipOptionSerializer < ActiveModel::Serializer
  include PublicAttributes::LineItemAttributes
  type 'membership-option'

  attributes :duration_in_words
end
