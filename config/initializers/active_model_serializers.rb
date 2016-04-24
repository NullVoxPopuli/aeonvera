require 'active_model_serializers'
ActiveModel::Serializer.config.adapter = :json_api
# Blegh...............
module ActiveModelSerializers::Adapter::JsonApi::Deserialization
  class << self
    def parse(document, options = {})
      document = document.dup.permit!.to_h if document.is_a?(ActionController::Parameters)

      # validate_payload(document) do |invalid_document, reason|
      #   yield invalid_document, reason if block_given?
      #   return {}
      # end

      primary_data = document['data']
      attributes = primary_data['attributes'] || {}
      attributes['id'] = primary_data['id'] if primary_data['id']
      relationships = primary_data['relationships'] || {}

      attributes = transform_keys(attributes, options)
      relationships = transform_keys(relationships, options)

      attributes = filter_fields(attributes, options)
      relationships = filter_fields(relationships, options)


      hash = {}
      hash.merge!(parse_attributes(attributes, options))
      hash.merge!(parse_relationships(relationships, options))

      hash
    end

    def filter_fields(fields, options)
      if (only = options[:only])
        only = Array(only).map { |o| o.to_s.underscore }
        fields.select { |k, _v| only.include?(k) }
      elsif (except = options[:except])
        except = Array(except).map { |o| o.to_s.underscore }
        fields.reject { |k, _v| except.include?(k) }
      else
        fields
      end
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

module ActiveModelSerializers

  module Deserialization
    module_function

    def jsonapi_parse(*args)
      Adapter::JsonApi::Deserialization.parse(*args)
    end
  end

end
