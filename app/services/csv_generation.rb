module CsvGeneration
  module_function

  def models_to_csv(models)
    CSV.generate do |csv|
      csv << models.first.keys
      models.each do |model|
        csv << model.values
      end
    end
  end
end
