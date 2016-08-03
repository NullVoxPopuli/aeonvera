module CsvGeneration
  module_function

  def model_to_csv(model, fields_from_params = nil)
    options = { adapter: :attributes }
    if fields_from_params
      fields = JSONAPI::IncludeDirective.new(fields_from_params).to_hash
      options[:fields] = ActiveModelSerializers::KeyTransform.underscore(fields)
    end
    hash = ActiveModelSerializers::SerializableResource.new(model, options).as_json

    hash = flat_hash(hash)
    collection_to_csv(hash)
  end

  def flat_hash(hash)
    return hash.map{|h| flat_hash(h)} if hash.is_a?(Array)
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
    CSV.generate do |csv|
      csv << models.first.keys
      models.each do |model|
        csv << model.values
      end
    end
  end
end
