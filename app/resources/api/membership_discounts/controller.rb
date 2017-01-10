# frozen_string_literal: true
module Api
  class MembershipDiscountsController < Api::HostResourceController
    before_action :must_be_logged_in

    private

    def update_line_item_params
      whitelistable_params(polymorphic: [:host]) do |whitelister|
        whitelister.permit(
          :code, :amount, :kind,
          :requires_student_id,
          :allowed_number_of_uses
        )
      end
    end

    def create_line_item_params
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
