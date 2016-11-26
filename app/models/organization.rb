# frozen_string_literal: true
# == Schema Information
#
# Table name: organizations
#
#  id                         :integer          not null, primary key
#  name                       :string(255)
#  tagline                    :string(255)
#  city                       :string(255)
#  state                      :string(255)
#  beta                       :boolean          default(FALSE), not null
#  owner_id                   :integer
#  deleted_at                 :datetime
#  created_at                 :datetime
#  updated_at                 :datetime
#  domain                     :string(255)
#  make_attendees_pay_fees    :boolean
#  logo_file_name             :string(255)
#  logo_content_type          :string(255)
#  logo_file_size             :integer
#  logo_updated_at            :datetime
#  notify_email               :string
#  email_all_purchases        :boolean          default(FALSE), not null
#  email_membership_purchases :boolean          default(FALSE), not null
#  contact_email              :string
#
# Indexes
#
#  index_organizations_on_domain  (domain)
#

class Organization < ActiveRecord::Base
  include SoftDeletable
  include HasPaymentProcessor
  include HasDomain
  include HasLogo

  belongs_to :owner, class_name: 'User'
  belongs_to :user, foreign_key: :owner_id
  belongs_to :hosted_by, class_name: 'User', foreign_key: :owner_id
  has_many :sponsorships, as: :sponsor
  has_many :sponsored_events,
    through: :sponsorships,
    source: :sponsored,
    source_type: Event.name

  # has_many :events
  # has_many :dances, class_name: "LineItem::Dance"
  # has_many :lessons, class_name: "LineItem::Lesson"
  # has_many :members
  has_many :collaborations, as: :collaborated
  has_many :collaborators, through: :collaborations, source: :user

  has_many :attendances, as: :host, class_name: OrganizationAttendance.name

  has_many :integrations,
    dependent: :destroy,
    extend: Extensions::Integrations,
    as: :owner

  has_many :line_items, as: :host

  has_many :orders, as: :host
  has_many :membership_discounts, as: :host

  has_many :dances,
    -> { where(item_type: LineItem::Dance.name) },
    class_name: LineItem::Dance.name, as: :host

  has_many :lessons,
    -> { where(item_type: LineItem::Lesson.name) },
    class_name: LineItem::Lesson.name, as: :host

  has_many :membership_options,
    -> { where(item_type: 'LineItem::MembershipOption') },
    class_name: LineItem::MembershipOption.name, as: :host

  # Members are just Users that have a relationship to an organization via:
  #  User -> Membership Renewal -> Membership Option -> Organization
  has_many :members, -> { uniq },
    through: :membership_options,
    source: :members

  alias_attribute :user_id, :owner_id

  # activeness is calculated and therefore can't
  # be directly queried :-(
  def active_members
    membership_options.map(&:active_members).flatten.uniq
  end

  def available_dances
    available_items(:dances, LineItem::Dance)
  end

  def available_lessons
    available_items(:lessons, LineItem::Lesson)
  end

  def location
    "#{city.titleize}, #{state.titleize}"
  end

  def link
    "//#{domain}.#{APPLICATION_CONFIG[:domain][Rails.env]}"
  end

  # a higher level of access
  def is_accessible_as_collaborator?(user)
    return false unless user
    return true if owner == user
    return true if user.collaborated_organization_ids.include?(id)

    false
  end

  private

  # Who needs SQL?
  def available_items(association_name, klass)
    table            = klass.arel_table
    starts_at_column = table[:registration_opens_at]
    closes_at_column = table[:registration_closes_at]
    now              = Time.now

    both_dates_exist         = starts_at_column.lt(now).and(closes_at_column.gt(now))
    only_closing_date_exists = starts_at_column.eq(nil).and(closes_at_column.gt(now))
    only_opening_date_exists = closes_at_column.eq(nil).and(starts_at_column.eq(now))
    no_dates                 = closes_at_column.eq(nil).and(starts_at_column.eq(nil))

    send(association_name)
      .where(no_dates
        .or(only_closing_date_exists
        .or(only_opening_date_exists
        .or(both_dates_exist))))
  end
end
