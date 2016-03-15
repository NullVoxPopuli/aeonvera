# object is actually an Attendance in this serializer
class IntegrationSerializer < ActiveModel::Serializer

  attributes :id,
    :name, :owner_id, :owner_type,
    :publishable_key

  belongs_to :owner

  def name
    object.kind
  end

  def publishable_key
    if object.kind == Integration::STRIPE
      return object.config[:stripe_publishable_key]
    end
  end



end
