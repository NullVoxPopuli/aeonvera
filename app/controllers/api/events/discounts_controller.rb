class Api::Events::DiscountsController < APIController
  include SetsEvent
  include LazyCrud

  set_resource_parent Event

  private

  def resource_params
    params[resource_singular_name].try(:permit,  [
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
