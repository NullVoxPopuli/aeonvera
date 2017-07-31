module Api
  class PricingTierSerializer < ActiveModel::Serializer
    include PublicAttributes::PricingTierAttributes
    attributes :number_of_leads, :number_of_follows

    has_many :registrations, each_serializer: ::Api::Users::RegistrationSerializer
    belongs_to :event

    def number_of_follows
      object.registrations.follows.count
    end

    def number_of_leads
      object.registrations.leads.count
    end
  end
end
