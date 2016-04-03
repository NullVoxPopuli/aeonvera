module PublicAttributes
  module CompetitionAttributes
    extend ActiveSupport::Concern

    included do
      attributes :id, :name,
        :initial_price, :at_the_door_price, :current_price,
        :kind, :kind_name,
        :requires_orientation, :requires_partner,
        :event_id
    end

    def requires_orientation
      object.requires_orientation?
    end

    def requires_partner
      object.requires_partner?
    end
  end
end
