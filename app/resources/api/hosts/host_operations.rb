# frozen_string_literal: true

module Api
  module HostOperations
    class Read < SkinnyControllers::Operation::Base
      def run
        model if allowed?
      end

      # Needs to be overridden, because a 'host' can be either
      # an Event or an Organization.
      #
      # TODO: come up with a better nome
      # TODO: think about combining these objects to a single table, so
      # inheritance is easier
      #
      # the params to this method should include the subdomain
      # e.g.: { subdomain: 'swingin2015' }
      def model_from_params
        subdomain = params[:subdomain]
        # first check the events, since those are more commonly used
        host = Event.find_by_domain(subdomain)
        # if the event doesn't exist, see if we have an organization
        host ||= Organization.find_by_domain(subdomain)

        if host.is_a?(Event)
          # reload with eagerness
          host = Event.includes(
            :packages,
            :competitions,
            :levels,
            :pricing_tiers,
            :custom_fields,
            :line_items,
            :shirts,
            :sponsorships
          ).find(host.id)
        end

        host
      end
    end
  end
end
