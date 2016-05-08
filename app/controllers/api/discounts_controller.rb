class Api::DiscountsController < Api::EventResourceController
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
