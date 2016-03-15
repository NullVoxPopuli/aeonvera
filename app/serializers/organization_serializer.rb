class OrganizationSerializer < ActiveModel::Serializer
  attributes :id, :name, :tagline,
    :city, :state, :beta, :owner_id,
    :domain, :url,
    :logo_file_name, :logo_content_type,
    :logo_file_size, :logo_updated_at,
    :logo_url_thumb, :logo_url_medium, :logo_url,
    :has_stripe_integration


  has_many :lessons
  has_many :integrations
  has_many :membership_options, serializer: MembershipOptionSerializer
  has_many :membership_discounts, serializer: MembershipDiscountSerializer

  def lessons
    object.available_lessons
  end

  def url
    object.link
  end

  def logo_url_thumb
    object.logo.url(:thumb)
  end

  def logo_url_medium
    object.logo.url(:medium)
  end

  def logo_url
    object.logo.url(:original)
  end

  def has_stripe_integration
    object.integrations[:stripe].present?
  end


end
