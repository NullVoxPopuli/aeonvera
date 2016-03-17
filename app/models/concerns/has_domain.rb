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
  ]

  included do

    alias_attribute :subdomain, :domain

    validate :domain_is_unique
    validates :domain, presence: true, exclusion: { in: DOMAIN_BLACKLIST }

    before_save { |event|
      text = (event.domain || event.name)
      event.domain = text.downcase.gsub(/\W|\s/, "")
    }

  end

  def url
    "//#{subdomain}.#{APPLICATION_CONFIG[:domain][Rails.env]}"
  end

  private

  # have to check both events and organizations
  def domain_is_unique
    my_table = self.class.arel_table
    id_column = my_table[:id]

    events_with_my_domain = Event.where(domain: self.domain)
    organizations_with_my_domain = Organization.where(domain: self.domain)

    # also don't pull us out of the db
    if self.is_a?(Event)
      ends_at_column = my_table[:ends_at]

      events_with_my_domain = events_with_my_domain.
        where(ends_at_column.gt(Time.now))

      if self.persisted?
        events_with_my_domain = events_with_my_domain.
          where(id_column.not_eq(self.id))
      end
    end

    if self.is_a?(Organization) and self.persisted?
      organizations_with_my_domain = organizations_with_my_domain.where(id_column.not_eq(self.id))
    end

    # is there another event with my domain?
    if events_with_my_domain.present?
      errors.add(:domain, 'is taken')
    end

    if organizations_with_my_domain.present?
      errors.add(:domain, 'is taken')
    end

  end
end
