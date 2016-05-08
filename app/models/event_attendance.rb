class EventAttendance < Attendance
  include ::EventItemHelpers
  include AttendanceDownloadableData


  belongs_to :event, class_name: Event.name,
   foreign_key: "host_id", foreign_type: "host_type", polymorphic: true

  belongs_to :level
  belongs_to :package
  belongs_to :pricing_tier

  # for an attendance, we don't care if any of our
  # references are deleted, we want to know what they were
  def package; Package.unscoped{ super }; end
  def level; Level.unscoped{ super }; end
  def event; Event.unscoped{ super }; end

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
  		join_table: "competition_responses",
  		association_foreign_key: "competition_id", foreign_key: "attendance_id"

  accepts_nested_attributes_for :competition_responses, allow_destroy: true


  has_and_belongs_to_many :discounts,
    join_table: "attendances_discounts",
    association_foreign_key: "discount_id", foreign_key: "attendance_id"


  scope :with_competitions, ->{
    joins(:competitions).group("attendances.id")
  }

  scope :with_packages, ->{
  joins(:package).group("attendances.id")
  }
  scope :with_package, ->(package_id) {
  where("package_id = #{package_id}")
  }

  scope :with_level, ->(level_id){
    where(level_id: level_id)
  }

  scope :with_a_la_cart, ->{
  joins(:a_la_cart).group("attendances.id")
  }

  scope :needing_housing, ->{ where(needs_housing: true) }
  scope :providing_housing, ->{ where(providing_housing: true) }
  scope :volunteers, ->{ where(interested_in_volunteering: true) }

  # validates :pricing_tier, presence: true
  validates :event, presence: true
  # validates :attendee, presence: true
  validates :package, presence: true
  validates :dance_orientation, presence: true, if: ->(a){ a.event.ask_if_leading_or_following? }
  validates :level, presence: true, if: Proc.new {|a| (p = a.package) && p.requires_track? }
  validate :has_address, if: Proc.new {|a| !(a.event.present? && event.started?)}
  validate :has_phone_number, if: Proc.new { |a| a.interested_in_volunteering? }
  validate :has_name, if: Proc.new { |a| a.attendee_id.blank? && a.attendee.blank? }


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

  def crossover_orientation=(o)
    self.metadata["crossover_orientation"] = o
  end

  def crossover_orientation
    self.metadata["crossover_orientation"]
  end


  def requested_housing_data
    metadata_safe["need_housing"]
  end

  def providing_housing_data
    metadata_safe["providing_housing"]
  end

  def phone_number
    metadata_safe['phone_number']
  end

  def phone_number=(phone)
    self.metadata ||= {} # TODO: why isn't this done on initialize?
    self.metadata['phone_number'] = phone
  end

  private

  def has_phone_number
    unless metadata_safe['phone_number'].present?
      errors.add('phone number', 'must be present when volunteering')
    end
  end

  def has_name
    unless metadata_safe['first_name'].present?
      errors.add('first name', 'must be present')
    end
    unless metadata_safe['last_name'].present?
      errors.add('last name', 'must be present')
    end
  end

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

    purchasable_items.each{ |c| total += c.current_price }
    discounts.each{ |d| total = d.apply_discount_to_total(total) }

    return total
  end

end
