class DiscountSerializer < ActiveModel::Serializer
  type 'discount'

  attributes :id, :code,
    :amount, :kind, :discount_type,
    :disabled,
    :applies_to,
    :host_id, :host_type,
    :allowed_number_of_uses, :requires_student_id,
    :times_used, :package_ids

    has_many :allowed_packages


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
