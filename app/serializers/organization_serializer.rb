class OrganizationSerializer < ActiveModel::Serializer
  attributes :id, :name, :tagline,
    :city, :state, :beta, :owner_id,
    :domain, :url,
    :logo_file_name, :logo_content_type,
    :logo_file_size, :logo_updated_at,
    :logo_url_thumb, :logo_url_medium, :logo_url,
    :has_stripe_integration,
    :make_attendees_pay_fees,
    :accept_only_electronic_payments,
    :notify_email,
    :email_all_purchases,
    :email_membership_purchases

  def accept_only_electronic_payments
    true
  end

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
