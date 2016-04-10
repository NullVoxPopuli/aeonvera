class Api::DiscountsController < Api::ResourceController
  private

  def update_discount_params
    ActiveModelSerializers::Deserialization
      .jsonapi_parse(params, only: [
        :code, :amount, :kind,
        :requires_student_id,
        :allowed_number_of_uses
      ])
  end

  def create_discount_params
    result = ActiveModelSerializers::Deserialization
      .jsonapi_parse(params, only: [
        :code, :amount, :kind,
        :requires_student_id,
        :allowed_number_of_uses,
        :host
      ], polymorphic: [:host])
    # types come in as ember lowercase and plural
    result[:host_type] = result[:host_type].classify
    result
  end
end
