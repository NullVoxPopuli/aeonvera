module Api
  # object is actually an Organization in this serializer
  class RegistrationSummarySerializer < ActiveModel::Serializer

    attributes :id, :type, :host_name,
      :date_registered, :owed_amount, :paid_amount,
      :begins, :ends, :status,
      :line_items


      def logo_url_thumb
        object.host.logo.url(:thumb)
      end

      def host_name
        object.host.name
      end

      def date_registered
        object.created_at
      end

      def type
        object.attendance_type
      end


  end
end
