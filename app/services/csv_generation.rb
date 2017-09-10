# frozen_string_literal: true

module CsvGeneration
  module_function

  def model_to_csv(model, fields_from_params = nil, skip_serialization: false, serializer:)
    options = { class: serializer }

    options.merge(options_from_fields(fields_from_params))

    hash = skip_serialization ? model : serialize_data(options, model)

    collection_to_csv(hash)
  end

  def serialize_data(options, model)
    jsonapi = renderer.render(model, options)

    included = {}
    jsonapi[:included].each do |i|
     included[i[:type]] ||= {}
     included[i[:id]] = i[:attributes]
    end if jsonapi[:included]

    hash = jsonapi[:data].map do |d|
     r = d[:attributes]
     d[:relationships].each do |k, v|
       id = v.dig(:data, :id)
       next unless id
       relations = included.dig(k, id)
       next unless relations
       relations.each do |j, x|
         r[j] = x
       end
     end
    end

    flat_hash(hash)
  end

  def options_from_fields(fields_from_params)
    return {} unless fields_from_params

    fields = JSONAPI::IncludeDirective.new(fields_from_params).to_hash
    f = {}
    i = []
    fields.each do |k, v|
      if !v.values.empty?
        key = k.to_s.pluralize.underscore.to_sym
        f[k.to_s.pluralize.to_sym] = v.keys.map(&:to_s).map(&:underscore)
        i << key
      else
        f[k] = v
      end
    end

    {
      fields: CaseTransform.underscore(f),
      include: i.join(',')
    }
  end

  def renderer
    @renderer ||= JSONAPI::Serializable::SuccessRenderer.new
  end

  def flat_hash(hash)
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
