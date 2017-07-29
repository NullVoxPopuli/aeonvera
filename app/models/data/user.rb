# frozen_string_literal: true
# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  first_name             :string(255)
#  last_name              :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  failed_attempts        :integer          default(0)
#  unlock_token           :string(255)
#  locked_at              :datetime
#  created_at             :datetime
#  updated_at             :datetime
#  deleted_at             :datetime
#  time_zone              :string(255)
#  authentication_token   :string
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  include SoftDeletable
  include HasMemberships

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :confirmable, :lockable # , :omniauthable

  has_many :integrations,
    dependent: :destroy,
    extend: Extensions::Integrations,
    as: :owner

  has_many :organizations, foreign_key: 'owner_id'
  has_many :hosted_events, class_name: 'Event', foreign_key: 'hosted_by_id'

  has_many :registrations, foreign_key: 'attendee_id'
  has_many :attended_events, through: :registrations, source: :host, source_type: Event.name

  has_many :collaborated_events, through: :collaborations, source: :collaborated, source_type: Event.name
  has_many :collaborated_organizations, through: :collaborations, source: :collaborated, source_type: Organization.name
  has_many :collaborations

  has_many :membership_renewals
  has_many :memberships, through: :membership_renewals, source: :membership_option

  has_many :levels
  has_many :discounts
  has_many :shirts
  has_many :packages
  has_many :competitions
  # has_many :housing_applicants
  # has_many :housing_providers

  has_many :orders

  validates :first_name, presence: true
  validates :last_name, presence: true

  before_destroy :not_attending_event?
  before_save :ensure_authentication_token

  ransacker :full_name do |parent|
    Arel::Nodes::NamedFunction.new(
      'concat_ws',
      [Arel::Nodes.build_quoted(' '), parent.table[:first_name], parent.table[:last_name]]
    )
  end

  # @return [Registration] the registration record for this user for the specified event
  def registration_for_event(event)
    registrations.where(host: event).first
  end

  # https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-sign-in-using-their-username-or-email-address
  # Overriding the find_for_database_authentication method allows you to edit database authentication ;
  # overriding find_for_authentication allows you to redefine authentication at a specific point (such as token,
  # LDAP or database). Finally, if you override the find_first_by_auth_conditions method, you can customize
  # finder methods (such as authentication, account unlocking or password recovery).
  # def self.find_first_by_auth_conditions(warden_conditions)
  #   # host = warden_conditions[:host]
  #   login = warden_conditions[:login]

  #   if login
  #     User.where(
  #       ["lower(username) = :value OR lower(email) = :value", {
  #          value: login.downcase
  #     }]).first
  #   elsif confirmation_token = warden_conditions[:confirmation_token]
  #     u = User.where(
  #       ["confirmation_token = :token", {
  #          token: confirmation_token
  #     }]).first
  #     ap warden_conditions
  #     ap u
  #     u
  #   elsif reset_token = warden_conditions[:reset_password_token]
  #     User.where(
  #       ["reset_password_token = :token", {
  #          token: reset_token
  #     }]).first
  #   elsif unlock_token = warden_conditions[:unlock_token]
  #     User.where(
  #       ["unlock_token = :token", {
  #          token: unlock_token
  #     }]).first
  #   elsif api_token = (warden_conditions[:api_key] or warden_conditions[:authentication_token])
  #     User.where(
  #       ["authentication_token = :token", {
  #          token: api_token
  #     }]).first
  #   elsif email = warden_conditions[:email]
  #     User.where(
  #       ["lower(email) = :email", {
  #          email: email.downcase
  #     }]).first
  #   end
  # end

  # There is something wrong with Devise as of Jan 5, 2014.
  # Confirmable is generating a new confirmation token, and using that
  # to try to find the user to be confirmed, which doesn't work, because they
  # user is saved with the original_token... not sure why this was originally
  # implemented the way that it was
  #
  # Find a user by its confirmation token and try to confirm it.
  # If no user is found, returns a new user with an error.
  # If the user is already confirmed, create an error for the user
  # Options must have the confirmation_token
  def self.confirm_by_token(confirmation_token)
    # original_token     = confirmation_token
    # confirmation_token = Devise.token_generator.digest(self, :confirmation_token, confirmation_token)
    confirmable = find_or_initialize_with_error_by(:confirmation_token, confirmation_token)
    confirmable.confirm! if confirmable.persisted?
    # confirmable.confirmation_token = original_token
    confirmable
  end

  # There is yet again something wrong with Devise (as of Jan 25 2014)
  # This is having the same issues as the confirm by token method, in that
  #  the are cerating a new token for no documented reason, and checking against that
  # instead of the token that was actually provided in the password reset request.
  # Below is the original method with the troublesome lines commented out
  #
  # Attempt to find a user by its reset_password_token to reset its
  # password. If a user is found and token is still valid, reset its password and automatically
  # try saving the record. If not user is found, returns a new user
  # containing an error in reset_password_token attribute.
  # Attributes must contain reset_password_token, password and confirmation
  def self.reset_password_by_token(attributes = {})
    # original_token       = attributes[:reset_password_token]
    # reset_password_token = Devise.token_generator.digest(self, :reset_password_token, original_token)

    # recoverable = find_or_initialize_with_error_by(:reset_password_token, reset_password_token)
    recoverable = find_or_initialize_with_error_by(:reset_password_token, attributes[:reset_password_token])

    if recoverable.persisted?
      if recoverable.reset_password_period_valid?
        recoverable.reset_password!(attributes[:password], attributes[:password_confirmation])
      else
        recoverable.errors.add(:reset_password_token, :expired)
      end
    end

    # recoverable.reset_password_token = original_token
    recoverable
  end

  def name
    "#{first_name} #{last_name}"
  end

  # unique union of the two sets of events
  # returns a relation, rather than an array, so we can still
  # use includes, and other active query things on the result.
  def hosted_and_collaborated_events
    ids = (collaborated_event_ids + hosted_event_ids).uniq
    events_table = Arel::Table.new(:events)
    id_column = events_table[:id]

    Event.where(id_column.in(ids))
  end

  def owned_and_collaborated_events
    hosted_and_collaborated_events
  end

  def owned_and_collaborated_organizations
    ids = (collaborated_organization_ids + organization_ids).uniq
    organizations_table = Arel::Table.new(:organizations)
    id_column = organizations_table[:id]

    Organization.where(id_column.in(ids))
  end

  def upcoming_events
    @upcoming_events ||= attended_events.where("starts_at > '#{Time.now.to_s(:db)}'")
  end

  def attending_upcoming_events?
    upcoming_events.present?
  end

  def is_a_manager_of?(host)
    (
      host.owner == self ||
      host.collaborators.include?(self)
    )
  end

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  protected

  # ensure that the user is not signed up for an upcoming event
  def not_attending_event?
    if attending_upcoming_events?
      event_names = upcoming_events.map(&:name).join(', ')
      errors[:base] << "You may not delete your account when you are attending an upcoming event. (#{event_names})"
      false
    end
  end

  def generate_authentication_token
    # loop so that we ensure we never get a duplicate token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end
end
