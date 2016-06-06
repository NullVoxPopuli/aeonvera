class DiscountSerializer < ActiveModel::Serializer
  include PublicAttributes::DiscountAttributes

  attributes :package_ids

  has_many :allowed_packages
  has_many :restraints, serializer: RestraintSerializer
  has_many :order_line_items
  belongs_to :host

  def package_ids
    object.allowed_package_ids
  end

  def requires_orientation
    object.requires_orientation?
  end

  def requires_partner
    object.requires_partner?
  end
end
