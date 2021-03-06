# frozen_string_literal: true

module Api
  class DiscountsController < Api::EventResourceController
    self.serializer = DiscountSerializableResource

    def index
      return super unless params[:q]

      params[:fields] = {
        discount: DiscountSerializableResource::PUBLIC_FIELDS
      }
      search = Event.find(event_id).discounts.ransack(params[:q])
      render_jsonapi(model: search.result)
    end

    def event_id
      params.require(:event_id)
    end

    private

    def update_discount_params
      whitelistable_params do |whitelister|
        whitelister.permit(
          :code, :amount, :kind,
          :requires_student_id,
          :allowed_number_of_uses
        )
      end
    end

    def create_discount_params
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
