class RegisterController < ApplicationController
  include CurrentSubdomain

  skip_before_filter :authenticate_user!
  before_filter :current_event, except: [ :register ]
  before_filter :authorized?, except: [ :index, :register, :countdown, :cancel  ]
  before_filter :set_attendance, only: [:set_payment_method, :confirm, :edit, :show, :update, :destroy]
  before_filter :registration_open?, only: [ :countdown ]
  before_filter :user_already_registered_for_this_event?, only: [ :create, :new, :index ]


  helper_method :current_event

  def cancel
    # delete the registration
    begin
      @attendance = current_event.attendances.find(params[:id])
      if @attendance and @attendance.owes_money?
        @attendance.destroy
        flash[:notice] = "You have cancelled your registration"
      else
        flash[:notice] = "You cannot cancel a registration you've paid for. Please contact the organizers if you wish to have a refund issued to you."
      end
    rescue ActiveRecord::NotFound => e
      # it's probably already deleted
    end

    redirect_to register_index_path
  end

  def set_payment_method
    @order = @attendance.orders.find(params[:order_id])
    @order.payment_method = params[:payment_method]
    @order.save
    redirect_to action: 'show'
  end

  # - create the attendance record for this user for this event
  # - let them review what they've signed up for before sending them off
  # to the payment service
  def create
    @attendance = current_event.attendances.build(registration_params)
    @attendance.attendee = current_user
    @attendance.pricing_tier_id = current_event.current_pricing_tier.id

    fix_housing_associations

    apply_discounts


    respond_to do |format|
      format.html {
        if @attendance.save
          order = update_or_create_order
          AttendanceMailer.thankyou_email(order: order).deliver
        else
          retrieve_competition_options
          # I gotta get out of this nested attributes shenanigans
          @attendance.housing_request ||= HousingRequest.new
          @attendance.housing_provision ||= HousingProvision.new
          return render action: "new"
        end

      }
    end
  end

  def countdown
    @date = current_event.registration_opens_at
  end

  def apply_discount
    # find the discount
    @discount = current_event.discounts.find_by_name(params[:code])

    if @discount && @discount.can_be_used?
      @attendance = current_event.attendances.find(params[:id])
      @order = @attendance.orders.find(params[:order_id])

      add_result = @order.add(@discount)
      if add_result
        if @order.save
          flash[:notice] = "Discount applied"
        else
          flash[:alert] = "Discount not applied"
        end
      else
        flash[:notice] = "Discount already applied"
      end

      redirect_to action: 'show', id: @attendance.id
    else
      flash[:alert] = "Discount not recognized"
      redirect_to action: 'show', id: params[:id]
    end
  end

  def edit
    @attendance.housing_request ||= HousingRequest.new
    @attendance.housing_provision ||= HousingProvision.new
    retrieve_competition_options
    if !@attendance.owes_money?
      flash[:notice] = "Please contact a #{current_event.name} organizer for help with editing your registration"
      redirect_to action: "show"
      return
    end
    #
    # figure this out later
    if current_event.electronic_payments_end_at && current_event.electronic_payments_end_at > Time.now
      flash[:alert] = "The deadline for registration edits has passed."
      redirect_to action: "show"
      return
    end
  end

  def index
    if current_user
      redirect_to action: "new"
    else
      cookies[:return_path] = request.original_url
    end
  end

  def new
    @attendance = EventAttendance.new
    @attendance.housing_request ||= HousingRequest.new
    @attendance.housing_provision ||= HousingProvision.new

    # throw in the custom fields
    current_event.custom_fields.each do |cf|
      @attendance.custom_field_responses << CustomFieldResponse.new(
        custom_field: cf
      )
    end

    retrieve_competition_options
  end

  def register
    @current_event = Event.find(params[:id])
    @attendance = EventAttendance.new

    render file: "/register/new"
  end

  def show
    if @attendance.orders.empty?
      @order = @attendance.new_order
      @order.save
    end
  end

  def update
    apply_discounts

    respond_to do |format|

      if @attendance.update(registration_params)
        # update_order_line_items
        update_or_create_order

        format.html{
          redirect_to action: "show"
        }
      else
        format.html{
          render action: "edit"
        }
      end
    end
  end

  def confirm
    @attendance = current_user.attendances.find(params[:id])

    # paypal returns a transaction id
    # check if they have already paid
    # by seeing if that transaction exists.
    # if it does, redirect the user to a copy of the receipt
    if not false # paid?
      # they havn't paid
      @order = @attendance.orders.unpaid.first
      pay_result = pay # redirect to paypal
      # redirect_to pay_result if pay_result
    else
      # they have already paid, redirect them to a page saying so
    end
  end



  # on the registration form, we need to find a discount by the name / code
  # ensure that that the requested discount exists
  def valid_discount
    code = params[:discount_code]

    begin
      @discount = current_event.discounts.find_by_name(code)
    rescue ActiveRecord::RecordNotFound => e
      @discount = nil
    end

    respond_to do |format|
      format.js do
        if @discount
          message = "#{@discount.discount} off of your #{@discount.affects}(s)"
          render json: { valid: true, id: @discount.id, message: message }
        else
          render json: { valid: false, message: "Invalid Discount Code" }
        end
      end
    end
  end


  ###################################
  # PRIVATE
  ###################################
  private

  def update_or_create_order
    @attendance.orders.unpaid.destroy_all
    order = @attendance.create_order

    if current_event.accept_only_electronic_payments?
      order.update!(payment_method: Payable::Methods::STRIPE)
    end

    order
  end

  def retrieve_competition_options
    @available_competitions = []

    # replace the list of all competitions with the participating ones
    participating_competitions = @attendance.competition_responses.map(&:competition)
    all_competitions = current_event.competitions

    all_competitions.each do |c|
      if !participating_competitions.include?(c)
        @available_competitions << CompetitionResponse.new(
          competition_id: c.id,
          attendance_id: @attendance.id
        )
      end
    end

  end

  def apply_discounts
    # associate discounts
    discounts = registration_params[:metadata][:discounts]
    if discounts.present?
      discounts.each do |code|
        discount = current_event.discounts.find_by_name(code)
        if not @attendance.discounts.include?(discount)
          @attendance.discounts << discount
        end
      end
    end

    ids = @attendance.discount_ids
    ids = ids.uniq
    @attendance.discount_ids = ids
    @attendance.save
  end

  def update_order_line_items
    order = @attendance.orders.unpaid.last
    order.line_items.each do |item|
      if item.line_item.is_a?(LineItem::Shirt)
        item.quantity = @attendance.total_quantity_for_shirt(item.line_item_id)
        item.save
      end
    end
  end

  def authorized?
    if current_event.blank?
      redirect_to root_url
    elsif current_event.registration_opens_at.utc > Time.now
      redirect_to countdown_register_index_path
    elsif not current_user.present?
      cookies[:return_path] = request.host_with_port
      redirect_to action: "index"
    end
    current_user
  end

  def registration_open?
    if @current_event.present? && @current_event.registration_opens_at.utc < Time.now
      redirect_to register_index_path
    end
  end

  def user_already_registered_for_this_event?
    if current_user && current_user.attended_events.include?(current_event)
      flash[:notice] = "You have already registered for this event. You may review your registration below."
      redirect_to register_path(current_user.attendance_for_event(current_event))
    end
  end


  def set_attendance
    begin
      @attendance = current_user.attendances.find(params[:id])
    rescue => e
      redirect_to root_url, notice: "Attendance Not Found"
    end
  end

  def current_event
    @current_event ||= Event.find_by_id(params[:event_id])
    @current_event ||= @attendance.event if @attendance

    ends_at_column = Event.arel_table[:ends_at]
    @current_event ||= Event.
      where(ends_at_column.gt(Time.now)).
      find_by_domain(current_subdomain)

    if !@current_event
      flash[:notice] = "Event was not found. Perhaps it was misspelled?"
      redirect_to calendar_home_index_url(subdomain: '')
      return false
    end
    @current_event
  end

  def fix_housing_associations
    if @attendance.housing_request.present?
      if @attendance.needs_housing? and registration_params[:housing_request_attributes].present?
        @attendance.housing_request.host = @attendance.host
        @attendance.housing_request.attendance_type = @attendance.class.name
      else
        @attendance.housing_request = nil
      end
    end

    if @attendance.housing_provision.present?
      if @attendance.providing_housing? and registration_params[:housing_provision_attributes].present?
        @attendance.housing_provision.host = @attendance.host
        @attendance.housing_provision.attendance_type = @attendance.class.name
      else
        @attendance.housing_provision = nil
      end
    end
  end


  # this is a super stupid amount of param
  # pre-processing
  #
  # O.O
  #
  # No one should ever do this
  def registration_params
    params[:attendance].permit(
      :package_id, :level_id,
      :needs_housing, :providing_housing,
      :interested_in_volunteering,
      :pricing_tier_id,
      :dance_orientation,
      discount_ids: [],
      custom_field_responses_attributes: [:custom_field_id, :value],
      competition_responses_attributes: [:id, :competition_id, :dance_orientation, :partner_name, :_destroy],
      housing_request_attributes: [
        :preferred_gender_to_house_with,
        :need_transportation,
        :can_provide_transportation,
        :transportation_capacity,
        :allergic_to_pets,
        :allergic_to_smoke,
        :other_allergies,
        :notes,
        requested_roommates: [],
        unwanted_roommates: []
      ],
      housing_provision_attributes:[
        :housing_capacity,
        :number_of_showers,
        :can_provide_transportation,
        :transportation_capacity,
        :preferred_gender_to_host,
        :has_pets,
        :smokes,
        :notes
      ],
      metadata: [
        :phone_number,
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
