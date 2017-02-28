# This migration is primarily to move away from attendances, and have orders be the atomic objects
# Befor this PR, attendances have that orders don't:
# - checked_in_at
# - attending
# - transfer data (to, reason, time)
# - volunteer interest
# - level? -- this should be moved to the package, and then selected as an
#             option in the UI within the cart
class AddColumnsToOrders < ActiveRecord::Migration
  def up
    add_column :orders, :cancelled, :boolean, default: false, null: false
    add_column :orders, :absorb_fees, :boolean, default: true, null: false
  end

  def down
    remove_column :orders, :absorb_fees
    remove_column :orders, :cancelled
  end

  # Example attendance with metadata (housing and address)
  #   #<EventAttendance:0x00000009d9cc28> {
  #                             :id => 22,
  #                    :attendee_id => 27,
  #                        :host_id => 4,
  #                       :level_id => 13,
  #                     :package_id => 10,
  #                :pricing_tier_id => 4,
  #     :interested_in_volunteering => true,
  #                  :needs_housing => false,
  #              :providing_housing => false,
  #                       :metadata => {
  #                  "need_housing" => {
  #                     "gender" => "No Preference",
  #             "transportation" => "0",
  #                  "allergies" => "",
  #                    "smoking" => "Indifferent",
  #                      "notes" => ""
  #         },
  #             "providing_housing" => {
  #                         "gender" => "No Preference",
  #                 "transportation" => "0",
  #                       "room_for" => "",
  #             "transportation_for" => "",
  #                        "smoking" => "0",
  #                      "have_pets" => "0"
  #         },
  #                       "address" => {
  #             "line1" => "1504 N street Ave",
  #             "line2" => "",
  #              "city" => "city",
  #             "state" => "state",
  #               "zip" => "12345"
  #         },
  #         "crossover_orientation" => "Intermediate Follows"
  #     },
  #                  :checked_in_at => Fri, 29 Aug 2014 20:23:05 EDT -04:00,
  #                     :deleted_at => nil,
  #                     :created_at => Wed, 16 Apr 2014 18:54:47 EDT -04:00,
  #                     :updated_at => Sat, 30 Aug 2014 14:14:38 EDT -04:00,
  #                      :attending => true,
  #              :dance_orientation => "Follow",
  #                      :host_type => "Event",
  #                :attendance_type => "EventAttendance",
  #            :transferred_to_name => nil,
  #         :transferred_to_user_id => nil,
  #                 :transferred_at => nil,
  #                :transfer_reason => nil
  # }
  # after the move to housing objects, it looks like,
  # the only metadata stored is the address and phone number
  def move_attendance_data_in_to_orders


  end
end
