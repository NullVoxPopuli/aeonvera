# frozen_string_literal: true

module Api
  class DiscountSerializableResource < ApplicationResource
    type 'discounts'

    PUBLIC_ATTRIBUTES = [:id, :code,
                         :amount, :kind, :discount_type,
                         :disabled,
                         :applies_to,
                         :requires_student_id].freeze

    PUBLIC_RELATIONSHIPS = [:host].freeze
    PUBLIC_FIELDS = Array[*PUBLIC_ATTRIBUTES, *PUBLIC_RELATIONSHIPS]

    attributes :code,
               :amount, :kind, :discount_type,
               :disabled,
               :applies_to,
               :allowed_number_of_uses, :requires_student_id,
               :times_used


    attribute(:package_ids) { @object.allowed_package_ids }

    has_many :allowed_packages, class: '::Api::PackageSerializableResource'
    has_many :restraints, class: '::Api::RestraintSerializableResource' do
      linkage always: true
    end
    has_many :order_line_items, class: '::Api::OrderLineItemSerializableResource'
    belongs_to :host, class: { Event: '::Api::EventSerializableResource',
                               Organization: '::Api::OrganizationSerializableResource' }
  end
end
