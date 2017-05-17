# frozen_string_literal: true
# == Schema Information
#
# Table name: attendances
#
#  id                         :integer          not null, primary key
#  attendee_id                :integer
#  host_id                    :integer
#  level_id                   :integer
#  package_id                 :integer
#  pricing_tier_id            :integer
#  interested_in_volunteering :boolean
#  needs_housing              :boolean
#  providing_housing          :boolean
#  metadata                   :text
#  checked_in_at              :datetime
#  deleted_at                 :datetime
#  created_at                 :datetime
#  updated_at                 :datetime
#  attending                  :boolean          default(TRUE), not null
#  dance_orientation          :string(255)
#  host_type                  :string(255)
#  attendance_type            :string(255)
#  transferred_to_name        :string
#  transferred_to_user_id     :integer
#  transferred_at             :datetime
#  transfer_reason            :string
#  attendee_first_name        :string
#  attendee_last_name         :string
#  phone_number               :string
#  city                       :string
#  state                      :string
#  zip                        :string
#
# Indexes
#
#  index_attendances_on_attendee_id                                (attendee_id)
#  index_attendances_on_host_id_and_host_type                      (host_id,host_type)
#  index_attendances_on_host_id_and_host_type_and_attendance_type  (host_id,host_type,attendance_type)
#

class EventAttendance < Attendance
  belongs_to :event, class_name: Event.name,
                     foreign_key: 'host_id', foreign_type: 'host_type', polymorphic: true

  belongs_to :level
  belongs_to :package
  belongs_to :pricing_tier

  # for an attendance, we don't care if any of our
  # references are deleted, we want to know what they were
  def package
    Package.unscoped { super }
  end

  def level
    Level.unscoped { super }
  end

  def event
    Event.unscoped { super }
  end

  # has_and_belongs_to_many :competitions,
  # join_table: "attendances_competitions",
  # association_foreign_key: "competition_id", foreign_key: "attendance_id"

  has_many :raffle_tickets,
    through: :order_line_items,
    source: :line_item,
    source_type: LineItem::RaffleTicket.name

  has_many :competition_responses,
    as: :attendance, class_name: CompetitionResponse.name,
    inverse_of: :attendance
  has_and_belongs_to_many :competitions,
    join_table: 'competition_responses',
    association_foreign_key: 'competition_id', foreign_key: 'attendance_id'

  accepts_nested_attributes_for :competition_responses, allow_destroy: true

  has_and_belongs_to_many :discounts,
    join_table: 'attendances_discounts',
    association_foreign_key: 'discount_id', foreign_key: 'attendance_id'

  scope :with_competitions, -> { joins(:competitions).group('attendances.id') }
  scope :with_packages, -> { joins(:package).group('attendances.id') }
  scope :with_package, ->(package_id) { where("package_id = #{package_id}") }
  scope :with_level, ->(level_id) { where(level_id: level_id) }

  scope :with_a_la_cart, -> { joins(:a_la_cart).group('attendances.id') }

  scope :needing_housing, -> { where(needs_housing: true) }
  scope :providing_housing, -> { where(providing_housing: true) }
  scope :volunteers, -> { where(interested_in_volunteering: true) }

  # validates :pricing_tier, presence: true
  validates :event, presence: true
  # validates :attendee, presence: true
  validates :package, presence: true
  # TODO: these are gross
  validates :dance_orientation, presence: true, if: ->(a) { a.event.ask_if_leading_or_following? }
  validates :level, presence: true, if: proc { |a| (p = a.package) && p.requires_track? }

  # for CSV output
  csv_with_columns [
    :attendee_name,
    :attendee_email,
    :package_name,
    :level_name,
    :amount_owed,
    :registered_at],
    exclude: [
      :updated_at, :created_at,
      :attendance_id, :attendance_type,
      :id,
      :host_id, :host_type]

  private

  def purchasable_items
    result = []
    result << competitions
    result << line_items
    result << shirts
    result.flatten!
    result
  end

  # if an attendance doesn't have an order, calculate things at
  # the current prices
  def total_cost
    total = 0

    total += package.current_price if package

    purchasable_items.each { |c| total += c.current_price }
    discounts.each { |d| total = d.apply_discount_to_total(total) }

    total
  end
end
