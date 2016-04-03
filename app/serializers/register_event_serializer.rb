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
end
