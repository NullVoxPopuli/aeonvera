class HostedEvents::Sales::RegisterController < ApplicationController
  include SetsEvent

    def index
      @attendance = Attendance.new
    end

  	def create
  		@attendance = Attendance.new(registration_params)
      @attendance.event = @event
      # @attendance.attendee = current_user
      @attendance.pricing_tier_id = @event.current_pricing_tier.id

      respond_to do |format|
        format.html {
          if @attendance.save
            order = @attendance.create_order

            if current_event.accept_only_electronic_payments?
              order.update!(payment_method: Payable::Methods::STRIPE)
            end

            AttendanceMailer.thankyou_email(order: order).deliver

          else
            return render action: "new"
          end

        }
      end
  	end

private
def registration_params
  params[:attendance].permit(
    :package_id, :level_id,
    :needs_housing, :providing_housing,
    :interested_in_volunteering,
    :pricing_tier_id,
    :dance_orientation,
    :discount_ids => [],
    metadata: [
      :phone_number,
      :first_name,
      :last_name,
      :email,
      :need_housing => [
        :gender,
        :transportation,
        :allergies,
        :smoking,
        :notes
      ],
      :providing_housing => [
        :gender,
        :transportation,
        :room_for,
        :transportation_for,
        :smoking,
        :have_pets
      ],
      address: [
        :line1,
        :line2,
        :city,
        :state,
        :zip
      ],
      shirts: {
        id: [
          sizes: {
            :size => [
              :quantity
            ]
          }
        ]
      }
    ],
    competition_ids: [],
    line_item_ids: []
  ).tap do |whitelisted|
    if shirts = params[:attendance].try(:[], :metadata).try(:[], :shirts)
      whitelisted[:metadata][:shirts] = shirts
      whitelisted[:line_item_ids] ||= []
      # make sure that any of the quantities are > 0
      add_to_line_items = false
      shirts.each{|shirt, shirt_data|
        shirt_data.each{ |size, data|
          if data && data['quantity'].to_i > 0
            add_to_line_items = true
            break
          end
        }
      }
      # the shirts need to be added to the line item ids, so that
      # we can record the price
      whitelisted[:line_item_ids] = whitelisted[:line_item_ids] + shirts.keys if add_to_line_items
    end
  end
end

end
