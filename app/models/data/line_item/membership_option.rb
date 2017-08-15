# frozen_string_literal: true

# == Schema Information
#
# Table name: line_items
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  price                  :decimal(, )
#  host_id                :integer
#  deleted_at             :datetime
#  created_at             :datetime
#  updated_at             :datetime
#  item_type              :string(255)
#  picture_file_name      :string(255)
#  picture_content_type   :string(255)
#  picture_file_size      :integer
#  picture_updated_at     :datetime
#  reference_id           :integer
#  metadata               :text
#  expires_at             :datetime
#  host_type              :string(255)
#  description            :text
#  schedule               :text
#  starts_at              :time
#  ends_at                :time
#  duration_amount        :integer
#  duration_unit          :integer
#  registration_opens_at  :datetime
#  registration_closes_at :datetime
#  becomes_available_at   :datetime
#  initial_stock          :integer          default(0), not null
#
# Indexes
#
#  index_line_items_on_host_id_and_host_type                (host_id,host_type)
#  index_line_items_on_host_id_and_host_type_and_item_type  (host_id,host_type,item_type)
#

class LineItem::MembershipOption < LineItem
  include Duration

  # this shouldn't need to be here, but rspec fails without,
  # even though the superclass has this exact association
  belongs_to :organization, class_name: Organization.name,
                            foreign_key: 'host_id', foreign_type: 'host_type', polymorphic: true

  has_many :renewals, class_name: '::MembershipRenewal'
  has_many :members, through: :renewals, source: :user

  has_many :order_line_items, -> {
    where(line_item_type: LineItem::MembershipOption.name)
  }, foreign_key: :line_item_id

  validates :name, presence: true
  validates :duration_amount, presence: true
  validates :duration_unit, presence: true
  validates :price, presence: true

  # expired, expires_at, and duration
  # are all computed fields, so we can't directly query
  # for active members
  def active_members
    active_renewals.map(&:user)
  end

  def active_renewals
    renewals.select { |r| !r.expired? }
  end

  def create_renewal_for_user(user, date: Time.now)
    renewal = renewals.new(
      user: user,
      start_date: date
    )
    renewal.save
    renewal
  end
end
