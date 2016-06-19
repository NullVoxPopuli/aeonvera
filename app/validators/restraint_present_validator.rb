class RestraintPresentValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    order = record.order
    line_item = record.line_item

    # restraint.restrictable == line_item
    # restraint.dependable == what is constraining
    restraints = line_item.try(:restraints)
    restraints = restraints.select { |r| r.dependable == line_item } if restraints

    if restraints.present?
      constrained_object_present = false

      restraints.each do |constraint|
        if order.line_item_matching(constraint.restrictable)
          constrained_object_present = true
        end
      end

      unless constrained_object_present
        record.errors.add(attribute, "(#{line_item.name}) #{attribute}'s constraint does not exist in the order")
      end
    end
  end

end
