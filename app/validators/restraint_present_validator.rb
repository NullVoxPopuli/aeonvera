# This prevents relationships from having differing parents
# For example, on an order line item,
# the order's host must be the same as the line item's host
class RestraintPresentValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    order = record.order
    line_item = record.line_item

    restraints = line_item.try(:restraints)

    if restraints.present?
      constrained_object_present = false

      restraints.each do |constraint|
        if order.line_item_matching(constraint.restrictable)
          constrained_object_present = true
        end
      end

      record.errors.add(attribute, "#{attribute}'s constraint does not exist in the order")
    end
  end

end
