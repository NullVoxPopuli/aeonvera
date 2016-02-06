class LineItem::MembershipOption < LineItem
  include Duration

  # this shouldn't need to be here, but rspec fails without,
  # even though the superclass has this exact association
  belongs_to :organization, class_name: Organization.name,
    foreign_key: "host_id", foreign_type: "host_type", polymorphic: true


  has_many :renewals, class_name: "::MembershipRenewal"
  has_many :members, through: :renewals, source: :user

  has_many :order_line_items, -> {
    where(line_item_type: LineItem::MembershipOption.name)
  }, foreign_key: :line_item_id

  validates :name, presence: true
  validates :duration_amount, presence: true
  validates :duration_unit, presence: true
  validates :price, presence: true

  def create_renewal_for_user(user, date: Time.now)
    renewal = self.renewals.new(
      user: user,
      start_date: date
    )
    renewal.save
    renewal
  end
end
