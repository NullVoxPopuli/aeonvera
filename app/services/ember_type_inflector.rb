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
  #
  # This is a lame hack, because ember doesn't namespace models
  #
  # Maybe I should just figure out how to get ember to namespace models,
  # or set which models are namespace on the ember side.
  # Worst case, I could get rid of the namespacing, but that would make
  # me feel bad. Though, in the grand scheme of things, there aren't THAT
  # many kinds of line items.... idk.
  NON_LINE_ITEMS = [
    MembershipDiscount.name, Package.name, Competition.name,
    Event.name, Organization.name, Discount.name,
    HousingRequest.name, HousingProvision.name,
    User.name, 'Member', 'Registration'
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
