# frozen_string_literal: true

module Api
  class RestraintSerializableResource < ApplicationResource
    type 'restraints'

    belongs_to :restriction_for, class: {
      Package: '::Api::PackageSerializableResource',
      Discount: '::Api::DiscountSerializableResource'
    } do
      data { @object.dependable }
    end

    belongs_to :restricted_to, class: {
      Discount: '::Api::DiscountSerializableResource',
      Package: '::Api::PackageSerializableResource'
    } do
      data { @object.restrictable }
    end
  end
end
