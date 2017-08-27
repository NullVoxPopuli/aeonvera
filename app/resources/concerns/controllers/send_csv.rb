module Controllers
  module SendCsv
    extend ActiveSupport::Concern

    def send_csv(model, serialize: true)
      csv_data = CsvGeneration
                  .model_to_csv(
                    model,
                    params[:fields],
                    skip_serialization: !serialize,
                    serializer: serializer
                  )

      send_data(csv_data)
    end
  end
end
