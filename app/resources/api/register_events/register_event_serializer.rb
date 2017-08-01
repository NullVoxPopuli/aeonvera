# frozen_string_literal: true
module Api
  class RegisterEventSerializer < ActiveModel::Serializer
    include PublicAttributes::EventAttributes

    class PackageSerializer < ActiveModel::Serializer
      include PublicAttributes::PackageAttributes
    end

    class CompetitionSerializer < ActiveModel::Serializer
      include PublicAttributes::CompetitionAttributes
    end

    class LevelSerializer < ActiveModel::Serializer
      include PublicAttributes::LevelAttributes
    end

    class PricingTierSerializer < ActiveModel::Serializer
      include PublicAttributes::PricingTierAttributes
    end

    class OpeningTierSerializer < PricingTierSerializer
      type 'opening_tier'
    end

    class CustomFieldSerializer < ActiveModel::Serializer
      attributes(::Api::CustomFieldSerializer::PUBLIC_ATTRIBUTES)

      belongs_to :host
    end
  end
end
