module Api
  class RegistrationDiscountSerializer < ActiveModel::Serializer
    include PublicAttributes::DiscountAttributes
  end
end
