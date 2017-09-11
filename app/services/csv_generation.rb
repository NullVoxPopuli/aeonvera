# frozen_string_literal: true

module CsvGeneration
  module_function

  def model_to_csv(model, fields_from_params = nil, skip_serialization: false, serializer:)
    options = { class: serializer }

    options.merge(options_from_fields(fields_from_params, serializer))

    hash = skip_serialization ? model : serialize_data(options, model)

    collection_to_csv(hash)
  end

  def serialize_data(options, model)
    jsonapi = renderer.render(Array[*model], options)
    data = jsonapi[:data]

    included = normalize_included(jsonapi[:included])

    hash = data.map do |d|
      merge_attributes_with_data(d[:attributes], d[:relationships], included, options)
    end.compact

    flat_hash(hash)
  end

  # TODO: make idiomatic
  def normalize_included(included)
    return {} unless included
    result = {}

    included.each do |i|
      result[i[:type]] ||= {}
      result[i[:type]][i[:id]] = i[:attributes]
    end

    result
  end

  def merge_attributes_with_data(attributes, relationships, included, options)
    attributes ||= {}
    included ||= {}
    result = attributes
    serializer = options[:class]
    fields = options[:fields]
    relationships = Array[*relationships]

    relationships.each do |k, v|
      next unless fields
      id = v.dig(:data, :id)
      next unless id

      field_relation_key = k.to_s.pluralize.to_sym

      field_relation = fields[field_relation_key]
      next unless field_relation.present?

      relation = serializer.relationship_options[k]
      # No support for polymorphic types
      next unless relation.is_a?(String)
      key = relation[:class].constantize.type_val
      relations = included.dig(key, id)
      next unless relations

      relations.each do |j, x|
        result[j] = x if field_relation.include?(j)
      end
    end

    result
  end

  def options_from_fields(fields_from_params, serializer)
    return {} unless fields_from_params

    fields = JSONAPI::IncludeDirective.new(fields_from_params).to_hash
    f = {}
    i = []
    fields.each do |k, v|
      if !v.values.empty?
        key = k.to_s.pluralize.underscore.to_sym
        f[k.to_s.pluralize.to_sym] = v.keys.map(&:to_s).map(&:underscore).map(&:to_sym)
        i << k
      else
        f[k] = v
      end
    end

    type = serializer.type_val

    underscored = CaseTransform.underscore(f)
    options = {
      fields: underscored
              .merge(type => underscored.keys.map(&:to_s).map(&:singularize).map(&:to_sym)),
      include: i.join(',')
    }

    options
  end

  def renderer
    @renderer ||= JSONAPI::Serializable::SuccessRenderer.new
  end

  def flat_hash(hash)
    return [] if hash.blank?
    return hash.map { |h| flat_hash(h) } if hash.is_a?(Array)

    result = {}
    hash.each do |k, v|
      if v.is_a?(Hash)
        result.merge!(v)
      else
        result[k] = v
      end
    end
    result
  end

  def collection_to_csv(models)
    return unless models.present?

    CSV.generate do |csv|
      csv << models.first.keys
      models.each do |model|
        csv << model.values
      end
    end
  end
end
