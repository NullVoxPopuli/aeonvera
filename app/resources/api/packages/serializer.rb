module Api
  class PackageSerializer < ActiveModel::Serializer
    include PublicAttributes::PackageAttributes

    attributes :number_of_leads, :number_of_follows

    belongs_to :event
    has_many :registrations


    def number_of_leads
      object.registrations.leads.count
    end

    def number_of_follows
      object.registrations.follows.count
    end
  end
end
