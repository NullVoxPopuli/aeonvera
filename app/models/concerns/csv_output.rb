module CSVOutput
  extend ActiveSupport::Concern

  included do
    class_attribute :methods_for_csv_output
    class_attribute :skip_methods_in_csv_output
  end

  def csv_field_values
    self.class.csv_fields.map do |method|
      self.send(method)
    end
  end

  module ClassMethods

    def csv_with_columns(list_of_columns, exclude: [])
      self.methods_for_csv_output = list_of_columns.map(&:to_sym)
      self.skip_methods_in_csv_output = exclude.map(&:to_sym)
    end

    def csv_fields
      specified_fields = (self.methods_for_csv_output || []) -
        (self.skip_methods_in_csv_output || [])

      (specified_fields.presence || column_names)
    end

    def to_csv(options = {})

      CSV.generate(options) do |csv|
        # convert fields to strings, and make them look nicer
        csv << csv_fields.map(&:to_s).map(&:titleize)
        all.each do |object|
          csv << object.csv_field_values
        end
      end
    end
  end
end
