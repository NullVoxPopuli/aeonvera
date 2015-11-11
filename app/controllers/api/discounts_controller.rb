class Api::DiscountsController < APIController
  include EventLoader
  # include LazyCrud
  #
  # set_resource_parent Event

  def index
    # TODO: should I check permissions of the discounts?
    render json: event.discounts, include: params[:include]
  end

  def show
    operation = Operations::Discount::Read.new(current_user, params)
    render json: operation.run
  end

  private

  def resource_proxy
    # current_user.hosted_and_collaborated_events
    current_user.hosted_events.find(params[:event_id]).discounts
  end

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
