# frozen_string_literal: true
module Api
  class RegistrationDiscountSerializer < ActiveModel::Serializer
    include PublicAttributes::DiscountAttributes
  end
end
