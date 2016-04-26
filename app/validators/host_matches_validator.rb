# This prevents relationships from having differing parents
# For example, on an order line item,
# the order's host must be the same as the line item's host
class HostMatchesValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    if options.key?(:with_host)
      host_path = options[:with_host]

      host = (
        if host_path.is_a?(String) && host_path.include?('.')
          host_parts = host_path.split('.')
          obj = record
          host_parts.each { |part| obj = obj.send(part) }
          obj
        else
          record.send(host_path)
        end
      )

      attribute_host = value.respond_to?(:host) ? value.host : value.event

      if host != attribute_host
        record.errors.add(attribute, "#{attribute}'s host does not match the #{host_path}'")
      end
    end
  end

end
