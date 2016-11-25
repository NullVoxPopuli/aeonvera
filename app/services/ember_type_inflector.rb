# frozen_string_literal: true
module EmberTypeInflector
  module_function

  def to_rails(hash)
    hash.each_with_object({}) do |(k, v), h|
      k_s = k.to_s
      if k_s.ends_with?('_type')
        h[k] = ember_type_to_rails(v)
      elsif k_s.ends_with?('_attributes')
        h[k] = if v.is_a?(Array)
                 v.map { |vh| to_rails(vh) }
               else
                 to_rails(v)
               end
      else
        h[k] = v
      end
    end.with_indifferent_access
  end

  # at this point, it'd be better to white list, than to black list
  NON_LINE_ITEMS = [
    MembershipDiscount.name, Package.name, Competition.name,
    Event.name, Organization.name, Discount.name,
    HousingRequest.name, HousingProvision.name,
    EventAttendance.name, Attendance.name
  ].freeze

  def ember_type_to_rails(key)
    return unless key
    key = key.underscore.classify

    unless NON_LINE_ITEMS.include?(key)
      key = key.include?('LineItem') ? key : "LineItem::#{key}"
    end

    key
  end
end
