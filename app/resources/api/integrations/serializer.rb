module Api
  # object is actually an Attendance in this serializer
  class IntegrationSerializer < ActiveModel::Serializer

    attributes :id,
      :kind, :owner_id, :owner_type,
      :publishable_key

    belongs_to :owner

    def publishable_key
      if object.kind == Integration::STRIPE
        return object.config.try(:[], 'stripe_publishable_key')
      end
    end



  end
end
