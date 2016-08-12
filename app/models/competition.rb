# frozen_string_literal: true
class Competition < ActiveRecord::Base
  include HasMetadata
  include SoftDeletable

  belongs_to :user
  belongs_to :event

  has_many :order_line_items, as: :line_item

  validates :kind, presence: true
  validates :name, presence: true
  validates :initial_price, presence: true
  validates :at_the_door_price, presence: true
  validates :event, presence: true

  SOLO_JAZZ = 0
  JACK_AND_JILL = 1
  STRICTLY = 2
  TEAM = 3
  CROSSOVER_JACK_AND_JILL = 4

  KIND_NAMES = {
    SOLO_JAZZ => 'Solo Jazz',
    JACK_AND_JILL => 'Jack & Jill',
    STRICTLY => 'Strictly',
    TEAM => 'Team',
    CROSSOVER_JACK_AND_JILL => 'Crossover Jack & Jill'
  }.freeze

  def kind_name
    KIND_NAMES[kind]
  end

  def requires_orientation?
    [JACK_AND_JILL, CROSSOVER_JACK_AND_JILL].include?(kind)
  end

  def requires_partner?
    kind == STRICTLY
  end

  def current_price
    initial_price
  end

  def to_competitor_csv(options = {})
    CSV.generate(options) do |csv|
      csv << ['Competition Number', 'Name', 'Dance Orientation', 'Partner Name'] # , "City", "State"]
      attendances.reorder(created_at: :asc).each do |attendance|
        competition_response = attendance.competition_responses.where(competition_id: id).first
        orientation = competition_response.try(:dance_orientation)
        partner_name = competition_response.try(:partner_name)

        row = [
          '',
          attendance.attendee_name,
          orientation || attendance.dance_orientation,
          partner_name
          # attendance.address["city"],
          # attendance.address["state"]
        ]
        csv << row
      end
    end
  end
end
