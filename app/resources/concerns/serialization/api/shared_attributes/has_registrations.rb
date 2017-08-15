# frozen_string_literal: true

module Api
  module SharedAttributes
    module HasRegistrations
      extend ActiveSupport::Concern

      included do
        attribute(:number_of_leads) { @object.registrations.leads.size }
        attribute(:number_of_follows) { @object.registrations.follows.size }
      end
    end
  end
end
