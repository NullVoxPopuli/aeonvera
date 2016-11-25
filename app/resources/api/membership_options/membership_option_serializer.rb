# frozen_string_literal: true
module Api
  class MembershipOptionSerializer < ActiveModel::Serializer
    include PublicAttributes::LineItemAttributes
    type 'membership_options'

    attributes :duration_in_words
  end
end
