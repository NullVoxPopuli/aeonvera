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
        leads = object.registrations.leads
        follows = object.registrations.follows
        [
          {
            name: 'Leads',
            children: registrations_breakdown(leads),
            size: leads.count
          },
          {
            name: 'Follows',
            children: registrations_breakdown(follows),
            size: follows.count
          }
        ]
      end

      def registrations_breakdown(registrations)
        by_packages = registrations.group_by(&:package_id)

        by_packages.map do |package_id, registrations_for_package|
          package = object.packages.find(package_id)
          {
            name: package.name,
            children: package_breakdown(package, registrations_for_package),
            size: registrations_for_package.count
          }
        end
      end

      def package_breakdown(package, registrations)
        if !package.requires_track
          # registrations.map{ |a| { name: a.attendee_name } }
          []
        else
          levels = object.levels

          levels.map do |level|
            registrations_for_level = registrations.select { |a| a.level_id == level.id }

            {
              name: level.name,
              size: registrations_for_level.count
              # children: registrations_for_level.map{ |a| { name: a.attendee_name }}
            }
          end
        end
      end
    end
  end
end
