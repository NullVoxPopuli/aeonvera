module Api
  class DiscountsController < Api::EventResourceController
    def index
      return super unless params[:q]
      search = Event.find(event_id).discounts.ransack(params[:q])
      render json: search.result, each_serializer: RegistrationDiscountSerializer
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
          :allowed_number_of_uses)
      end
    end

    def create_discount_params
      whitelistable_params(polymorphic: [:host]) do |whitelister|
        whitelister.permit(
          :code, :amount, :kind,
          :requires_student_id,
          :allowed_number_of_uses,
          :host_id, :host_type)
      end
    end
  end
end
