# frozen_string_literal: true
module Api
  module PublicAttributes
    module DiscountAttributes
      extend ActiveSupport::Concern

      included do
        type 'discounts'

        attributes :id, :code,
                   :amount, :kind, :discount_type,
                   :disabled,
                   :applies_to,
                   :host_id, :host_type,
                   :allowed_number_of_uses, :requires_student_id,
                   :times_used
      end
    end
  end
end
