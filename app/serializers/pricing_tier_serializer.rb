class PricingTierSerializer < ActiveModel::Serializer
  include PublicAttributes::PricingTierAttributes
  attributes :number_of_leads, :number_of_follows
  
  has_many :attendances

  def number_of_follows
    object.attendances.follows.count
  end

  def number_of_leads
    object.attendances.leads.count
  end
end
