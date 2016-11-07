require 'active_model_serializers'
ActiveModelSerializers.config.adapter = :json_api
ActiveModelSerializers.config.serializer_lookup_chain.unshift(
  lambda do |resource_class, _, namespace|
    "#{namespace.name}::#{resource_class.name}Serializer" if namespace
  end
  # ] + ActiveModelSerializers::LookupChain::DEFAULT.dup
)


# TODO: switch to unaltered when bf4's belongs_to PR is ready
# ActiveModelSerializers.config.key_transform = :unaltered

# properly handle JSON API Accept/Content-Type
# require 'active_model_serializers/register_jsonapi_renderer'

# Blegh...............
module ActiveModelSerializers::Adapter::JsonApi::Deserialization
  class << self
    def validate_payload(document, &block)
      # TODO: modify this to accept embedded documents
      true
    end

    # https://github.com/spieker/active_model_serializers-jsonapi_embedded_records_deserializer/blob/master/lib/active_model_serializers/jsonapi_embedded_records_deserializer.rb
    def parse_relationship(assoc_name, assoc_data, options)
      prefix_key = field_key(assoc_name, options).to_s.singularize
      hash =
        if (options[:embedded] || []).include?(assoc_name.to_sym)
          parse_nested_attributes(assoc_name, assoc_data, options)
        elsif assoc_data.is_a?(Array)
          { "#{prefix_key}_ids".to_sym => assoc_data.map { |ri| ri['id'] } }
        else
          { "#{prefix_key}_id".to_sym => assoc_data ? assoc_data['id'] : nil }
        end

      polymorphic = (options[:polymorphic] || []).include?(assoc_name.to_sym)
      if polymorphic
        hash["#{prefix_key}_type".to_sym] = assoc_data.present? ? assoc_data['type'] : nil
      end

      hash
    end

    def parse_nested_attributes(assoc_name, assoc_data, options)
      data =
        if assoc_data.is_a?(Array)
          assoc_data.map { |ri| parse({ 'data' => ri }, options) }
        elsif assoc_data.is_a?(Hash)
          parse({ 'data' => assoc_data }, options)
        end
      { "#{assoc_name}_attributes".to_sym => data }
    end
  end
end


# for applying fields filtering to attributes
module ActiveModelSerializers
  module Adapter
    class Attributes < Base
      def serializable_hash(options = nil)
        options = serialization_options(options)
        options[:fields] ||= instance_options[:fields]
        hash = serializer.serializable_hash(instance_options, options, self)
        fields = JSONAPI::IncludeDirective.new(options[:fields]).to_hash
        apply_fields_whitelist(hash, fields)
      end

      # this is a little backwards, but it's needed until AMS has a more unified interface
      def apply_fields_whitelist(hash, fields)
        return hash.map{ |e| apply_fields_whitelist(e, fields) } if hash.is_a?(Array)

        result = {}
        fields_keys = fields.keys
        hash.each do |k, v|
          next unless fields_keys.include?(k)
          if v.is_a?(Hash)
            result[k] = apply_fields_whitelist(v, fields[k])
          else
            result[k] = v
          end
        end

        result
      end
    end
  end
end
