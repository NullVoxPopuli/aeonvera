class HostedEvents::DiscountsController < ApplicationController
  include SetsEvent
  include LazyCrud

  set_resource Discount
  set_resource_parent Event
  layout "edit_event"

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

  # re-organizes restraints_attributes and
  # add_restraints_attributes into a single 'array'
  # for accepts_nested_attributes
  #
  # 1. Check if entries in add_restraints_attributes
  #    already exist on the resource
  # 2. If they don't already exist, add them to
  #    restraints_attributes
  # 3. Merge with possible modifcations on existing restraints
  def filter_restraint_params(whitelisted)
    restraints = whitelisted[:restraints_attributes]
    new_restraints = whitelisted[:add_restraints_attributes] || {}
    valid_new_restraints = {}

    # if both are empty, what's the point?
    return unless (restraints.present? || new_restraints.present?)

    restraints = (restraints || {}).keep_if { |index, r| r[:id].present? }

    if @resource
      existing_restraints = @resource.restraints

      valid_new_restraints = new_restraints.keep_if { |index, r|
        # check for empty, ensuring that the restraint
        # doesn't currently exist
        !r[:_destroy].to_b &&
        existing_restraints.select   { |restraint|
          restraint.id == r[:restrictable_id]
          restraint.class.name == r[:restrictable_type]
        }.empty?
      }
    end

    # merge
    if restraints.present?
      highest_index = restraints.keys.sort.last.to_i

      valid_new_restraints.each do |index, r|
        highest_index = highest_index + 1
        restraints[highest_index.to_s] = r
      end
    else
      restraints = valid_new_restraints
    end

    restraints
  end

end
