module Controllers
  module SendCsv
    extend ActiveSupport::Concern

    def send_csv(model)
      csv_data = CsvGeneration.model_to_csv(model, params[:fields])
      send_data(csv_data)
    end
  end
end
