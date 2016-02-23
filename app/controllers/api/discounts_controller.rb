class Api::DiscountsController < Api::ResourceController
  private

  def update_discount_params
    params
      .require(:data)
      .require(:attributes)
      .permit(:code, :amount, :kind, :requires_student_id)
  end

  def create_discount_params
    attributes = update_discount_params
    relationship = params
      .require(:data).require(:relationships)
      .require(:host).require(:data).permit(:id, :type)
  end

  def resource_params
    params[:discount].try(:permit,  [
      :value, :name, :kind,
      :affects, :allowed_number_of_uses,
      restraints_attributes: [
        :id, :restrictable_id, :restrictable_type, :_destroy
      ],
      add_restraints_attributes: [
        :restrictable_id, :restrictable_type, :_destroy
      ]
    ]).tap do |whitelisted|
      whitelisted[:restraints_attributes] = filter_restraint_params(whitelisted)
      whitelisted.delete(:restraints_attributes) if whitelisted[:restraints_attributes].blank?
      whitelisted.try(:delete, :add_restraints_attributes)
    end
  end
end
