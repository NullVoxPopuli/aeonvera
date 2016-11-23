module Api
  module Chart
    class RegistrationBreakdownSerializer < ActiveModel::Serializer
      type 'charts'

      attributes :id, :root_node

      def id
        "#{object.id}-registration-breakdown"
      end

      def root_node
        {
          name: 'Registrations',
          children: breakdown
        }
      end

      def breakdown
        leads = object.attendances.leads
        follows = object.attendances.follows
        [
          {
            name: 'Leads',
            children: attendances_breakdown(leads),
            size: leads.count
          },
          {
            name: 'Follows',
            children: attendances_breakdown(follows),
            size: follows.count
          }
        ]
      end

      def attendances_breakdown(attendances)
        by_packages = attendances.group_by(&:package_id)

        by_packages.map do |package_id, attendances_for_package|
          package = object.packages.find(package_id)
          {
            name: package.name,
            children: package_breakdown(package, attendances_for_package),
            size: attendances_for_package.count
          }
        end
      end

      def package_breakdown(package, attendances)
        if !package.requires_track
          # attendances.map{ |a| { name: a.attendee_name } }
          []
        else
          levels = object.levels

          levels.map do |level|
            attendances_for_level = attendances.select{ |a| a.level_id == level.id }

            {
              name: level.name,
              size: attendances_for_level.count
              # children: attendances_for_level.map{ |a| { name: a.attendee_name }}
            }
          end
        end
      end
    end
  end
end
