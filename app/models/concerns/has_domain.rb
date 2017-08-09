# frozen_string_literal: true

module HasDomain
  extend ActiveSupport::Concern

  DOMAIN_BLACKLIST = [
    'welcome', 'user',
    'events', 'organizations', 'communities',
    'login', 'logout', 'signup',
    'donation-thankyou',
    'password-reset',
    'dance-event', 'dance-community',
    'dashboard',
    'orders',
    'event-at-the-door',
    'hosted-events', 'upcoming-events',
    'register'
  ].freeze

  included do
    alias_attribute :subdomain, :domain

    validate :domain_is_unique
    validates :domain, presence: true, exclusion: { in: DOMAIN_BLACKLIST }

    before_save do |event|
      text = (event.domain || event.name)
      event.domain = text.downcase.gsub(/\W|\s/, '')
    end
  end

  def url
    # "//#{subdomain}.#{APPLICATION_CONFIG[:domain][Rails.env]}"
    "//#{APPLICATION_CONFIG[:domain][Rails.env]}/#{subdomain}"
  end

  private

  # have to check both events and organizations
  def domain_is_unique
    my_table = self.class.arel_table
    id_column = my_table[:id]

    events_with_my_domain = Event.where(domain: domain)
    organizations_with_my_domain = Organization.where(domain: domain)

    # also don't pull us out of the db
    if is_a?(Event)
      ends_at_column = my_table[:ends_at]

      events_with_my_domain = events_with_my_domain
                              .where(ends_at_column.gt(Time.now))

      if persisted?
        events_with_my_domain = events_with_my_domain
                                .where(id_column.not_eq(id))
      end
    end

    if is_a?(Organization) && persisted?
      organizations_with_my_domain = organizations_with_my_domain.where(id_column.not_eq(id))
    end

    # is there another event with my domain?
    errors.add(:domain, 'is taken') if events_with_my_domain.present?

    errors.add(:domain, 'is taken') if organizations_with_my_domain.present?
  end
end
