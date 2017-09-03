# frozen_string_literal: true

module Api
  module ChartDataPresenters
    class RegistrationBreakdownPresenter < ApplicationPresenter
      def root_node
        {
          name: 'Registrations',
          children: breakdown
        }
      end

      def breakdown
        @levels = object.levels
        packages = Package
                   .includes(order_line_items: [order: [:registration]])
                   .where(event_id: object.id)

        packages.map do |package|
          order_line_items = package.order_line_items

          {
            name: package.name,
            children: package_breakdown(package),
            size: order_line_items.count
          }
        end
      end

      def package_breakdown(package)
        if !package.requires_track
          donce_orientation_breakdown(object.registrations.where(level_id: nil))
        else
          @levels.map do |level|
            registrations_for_level = level.registrations

            {
              name: level.name,
              size: registrations_for_level.count,
              children: donce_orientation_breakdown(registrations_for_level)
            }
          end
        end
      end

      def donce_orientation_breakdown(registrations)
        [
          {
            name: 'Leads',
            size: registrations.leads.count
          },
          {
            name: 'Follows',
            size: registrations.follows.count
          }
        ]
      end
    end
  end
end
