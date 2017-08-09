# frozen_string_literal: true

module AssertParameters
  def assert!(object, requires = '', message: nil)
    value = asserted_value(object, requires)
    result = block_given? ? yield(value) : value.present?

    message ||= "Expected parameter to have property #{requires}"
    raise message unless result
  end

  def asserted_value(object, property)
    object.send(property) if object.respond_to?(property)
  end
end
