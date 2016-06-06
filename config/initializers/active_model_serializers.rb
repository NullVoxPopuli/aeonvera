require 'active_model_serializers'
ActiveModel::Serializer.config.adapter = :json_api
# Blegh...............
module ActiveModelSerializers::Adapter::JsonApi::Deserialization
  class << self
    def validate_payload(document, &block)
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


# for dynamic type
module ActiveModel
  class Serializer
    def json_key
      root ||
        (_type && _type.is_a?(Proc) ? _type.call(object) : _type) ||
        object.class.model_name.to_s.underscore
    end

    class << self
      def type(type)
        self._type = type.is_a?(Proc) ? type : type.to_s if type
      end
    end
  end
end

module ActiveModelSerializers
  module Adapter
    class JsonApi
      class ResourceIdentifier

        private

        def type_for(serializer)
          return serializer._type.call if serializer._type.is_a?(Proc)
          return serializer._type if serializer._type
          if ActiveModelSerializers.config.jsonapi_resource_type == :singular
            serializer.object.class.model_name.singular
          else
            serializer.object.class.model_name.plural
          end
        end
      end
    end
  end
end
