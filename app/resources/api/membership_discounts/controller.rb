# frozen_string_literal: true

module Api
  class MembershipDiscountsController < UserResourceController
    self.resource_class = ::MembershipDiscount
    self.serializer_class = MembershipDiscountSerializableResource
    # self.parent_resource_method = :organization

    private

    def update_membership_discount_params
      whitelistable_params do |whitelister|
        whitelister.permit(
          :code, :amount, :kind,
          :requires_student_id,
          :allowed_number_of_uses
        )
      end
    end

    def create_membership_discount_params
      whitelistable_params(polymorphic: [:host]) do |whitelister|
        whitelister.permit(
          :code, :amount, :kind,
          :requires_student_id,
          :allowed_number_of_uses,
          :host_id, :host_type
        )
      end
    end
  end
end
