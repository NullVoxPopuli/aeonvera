module PublicAttributes
  module LineItemAttributes
    extend ActiveSupport::Concern

    included do
      attributes :id,
        :name, :current_price, :price,
        :host_id, :host_type,
        :event_id, :number_purchased,
        :starts_at, :ends_at, :schedule,
        :duration_amount, :duration_unit,
        :registration_opens_at, :registration_closes_at,
        :description,
        :expires_at,
        :picture_url_thumb,
        :picture_url_medium,
        :picture_url

      belongs_to :host
    end

    def event_id
      object.host_id
    end

    def number_purchased
      object.order_line_items.count
    end

    def picture_url_thumb
      object.picture.url(:thumb)
    end

    def picture_url_medium
      object.picture.url(:medium)
    end

    def picture_url
      object.picture.url(:original)
    end
  end
end
