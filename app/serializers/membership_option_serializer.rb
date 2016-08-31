class MembershipOptionSerializer < ActiveModel::Serializer
  include PublicAttributes::LineItemAttributes
  type 'membership_option'

  attributes :duration_in_words
end
