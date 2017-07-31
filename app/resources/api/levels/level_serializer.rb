module Api
  class LevelSerializer < ActiveModel::Serializer
    include PublicAttributes::LevelAttributes
    attributes :number_of_leads, :number_of_follows

    belongs_to :event
    has_many :registrations, each_serializer: ::Api::Users::RegistrationSerializer

    def registrations
      object.registrations
    end

    def number_of_follows
      object.registrations.follows.count
    end

    def number_of_leads
      object.registrations.leads.count
    end
  end
end
