class HostedEventsController < ApplicationController
  include SetsEvent

  skip_before_action :set_event, only: [:index, :new, :create]

  # authorizable(
  #   edit: {
  #     target: :event,
  #     redirect_path: Proc.new{ hosted_event_path(@event) }
  #   },
  #   create: {
  #     permission: :can_create_event?,
  #     redirect_path: Proc.new{ hosted_events_path }
  #   },
  #   destroy: {
  #     target: :event,
  #     redirect_path: Proc.new{ hosted_event_path(@event) }
  #   }
  # )


  # GET /events
  # GET /events.json
  def index
    @events = current_user.hosted_events
    @collaborated_events = current_user.collaborated_events
    render layout: "application"
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event_decorator = @event.decorate
  end

  # GET /events/new
  def new
    @event = Event.new
    render layout: "application"
  end

  # GET /events/1/edit
  def edit
    render layout: "edit_event"
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    @event.hosted_by = current_user

    respond_to do |format|
      if @event.save
        format.html { redirect_to hosted_events_path(@event), notice: 'Event was successfully created.' }
        format.json { render action: 'show', status: :created, location: @event }
      else
        format.html { render action: 'new', layout: "application" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to hosted_event_path(@event), notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to hosted_events_url }
      format.json { head :no_content }
      format.js { }
    end
  end

  # GET /events/1/un_destroy
  def un_destroy
    @event = current_user.hosted_events.with_deleted.find(params[:id])

    @event.soft_undelete!
    respond_to do |format|
      format.html { redirect_to hosted_events_url }
      format.json { head :no_content }
      format.js { }
    end
  end

  def a_la_carte_orders
    @orders = @event.orders.where('orders.attendance_id IS NULL')
  end


  def public_registration
    subdomain = @event.subdomain
    redirect_to "#{request.protocol}#{subdomain}.#{request.host_with_port.gsub("www.", "")}#"
  end

  def pricing_tables
    @packages = @event.packages
    @pricing_tiers = @event.pricing_tiers
  end

  def volunteers
    respond_to do |format|
      format.html{ }
      format.csv{
        send_data @event.attendances.volunteers.to_volunteer_csv
      }
    end
  end


  def charts
    respond_to do |format|
      format.html{}
      format.json{

        values = []
        money_values = []
        count = 0
        money = 0

        attendances = @event.attendances.reorder("created_at ASC")
        attendances.each do |attendance|
          time = attendance.created_at.to_i
          values << [
            time,
            count += 1
          ]
        end

        orders = @event.orders.reorder("created_at ASC")
        orders.each do |order|
          time = order.created_at.to_i
          money_values << [
            time,
            money += order.paid ? order.total : 0
          ]
        end

        @data = {
          registrations: [{
                            key: "Registrations",
                            values: values
          }],
          revenue: [{
                      key: "Revenue ($)",
                      values: money_values
          }]
        }

        render json: @data.to_json
      }
    end
  end

  def packet_printout

  end

  def revenue
    # @a_la_cart = @event.attendances.with_a_la_cart
    @attendances = Attendance.where(host_id: @event.id, host_type: Event.name).includes(:orders)
    @orders = @attendances.map(&:orders).flatten

    paid_orders = @orders.select{ |o| o.paid? }
    unpaid_orders = @orders.select{ |o| !o.paid? }


    @owed = @event.unpaid_total || 0
    @revenue = paid_orders.map(&:net_received).inject(:+) || 0
    @expecting = @owed + @revenue || 0


    @payment_breakdown = {}
    Payable::Methods::ALL.each do |payment_type|
      orders = paid_orders.select{ |o| o.payment_method == payment_type }
      @payment_breakdown[payment_type] = orders.map(&:net_received).inject(:+)
    end
    @total = @payment_breakdown.inject(0){ | sum, tuple | sum += tuple[1].to_f }

    revenue_from_paypal = @payment_breakdown[Payable::Methods::PAYPAL]
    paypal_orders = paid_orders.select{ |o| o.payment_method == Payable::Methods::PAYPAL }
    stripe_orders = paid_orders.select{ |o| o.payment_method == Payable::Methods::STRIPE }

    # PayPal's fees are typically 2.9% + $0.30 USD
    @paypal_fees = Order.paypal_fees(paypal_orders) || 0
    @stripe_fees = stripe_orders.map(&:total_fee_amount).inject(:+) || 0

    @net_revenue = @total - @paypal_fees || 0

    # day by day
    # @day_reports = {}
    # days = ((@event.starts_at + 4.days) - @event.starts_at) / 1.day.to_i
    # days.round.times do |day_offset|
    #   time = @event.starts_at + day_offset.days
    #   start = time.beginning_of_day + 2.hours
    #   ending = time.end_of_day + 2.hours
    #   payment_breakdown = {}
    #   payment_orders = {}
    #   Payable::Methods::ALL.each do |payment_type|
    #     orders = @event.orders.created_after(start).created_before(ending).paid.where(payment_method: payment_type)
    #     payment_breakdown[payment_type] = orders.map(&:net_received).inject(:+)
    #     payment_orders[payment_type] = orders
    #   end
    #
    #   total = payment_breakdown.inject(0){ | sum, tuple | sum += tuple[1].to_f }
    #   paypal_fees = @event.orders.paid.created_after(start).created_before(ending).where(payment_method: Payable::Methods::PAYPAL)
    #   paypal_fees = Order.paypal_fees(paypal_fees)
    #
    #   @day_reports[Date::DAYNAMES[time.wday]] = {
    #     payment_breakdown: payment_breakdown,
    #     payment_orders: payment_orders,
    #     total: total,
    #     paypal_fees: paypal_fees.to_f,
    #     net: total - paypal_fees.to_f,
    #     start: start,
    #     ending: ending
    #   }
    #   @day_reports[:name] = "Whole Day"
    #
    # end
    #
    # @evening_reports = {}
    # @pre_evening_reports = {}
    #
    # days.round.times do |day_offset|
    #   time = @event.starts_at + day_offset.days
    #   start = time.end_of_day - 5.hours
    #   ending = time.end_of_day + 2.hours
    #
    #   payment_breakdown = {}
    #   payment_orders = {}
    #   Payable::Methods::ALL.each do |payment_type|
    #     orders = @event.orders.created_after(start).created_before(ending).paid.where(payment_method: payment_type)
    #     payment_breakdown[payment_type] = orders.map(&:total).inject(:+)
    #     payment_orders[payment_type] = orders
    #   end
    #
    #   total = payment_breakdown.inject(0){ | sum, tuple | sum += tuple[1].to_f }
    #   paypal_fees = @event.orders.paid.created_after(start).created_before(ending).where(payment_method: Payable::Methods::PAYPAL)
    #   paypal_fees = Order.paypal_fees(paypal_fees)
    #
    #   day = Date::DAYNAMES[time.wday]
    #   @evening_reports[day + " Evening"] = {
    #     payment_breakdown: payment_breakdown,
    #     payment_orders: payment_orders,
    #     total: total,
    #     paypal_fees: paypal_fees.to_f,
    #     net: total - paypal_fees.to_f,
    #     start: start,
    #     ending: ending
    #   }
    #   @evening_reports[:name] = "Evening"
    #
    #   pre_payment_breakdown = {}
    #   pre_payment_orders = {}
    #   Payable::Methods::ALL.each do |payment_type|
    #     pre_payment_breakdown[payment_type] = (@day_reports[day][:payment_breakdown][payment_type] || 0) - (payment_breakdown[payment_type] || 0)
    #     pre_payment_orders[payment_type] = (@day_reports[day][:payment_orders][payment_type] - payment_orders[payment_type])
    #   end
    #
    #   @pre_evening_reports[day + "Pre-Evening"] = {
    #     name: "Pre Evening",
    #     payment_breakdown: pre_payment_breakdown,
    #     payment_orders: pre_payment_orders,
    #     total: @day_reports[day][:total] - total,
    #     paypal_fees: @day_reports[day][:paypal_fees] - paypal_fees.to_f,
    #     net: @day_reports[day][:net] - (total - paypal_fees.to_f),
    #     start: @day_reports[day][:start],
    #     ending: start
    #   }
    #   @pre_evening_reports[:name] = "Pre-Evening"
    # end



  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def event_params
    params[:event].permit(
      :name, :short_description, :starts_at, :ends_at, :payment_email,
      :domain,
      :allow_discounts,
      :accept_only_electronic_payments,
      :allow_combined_discounts,
      :registration_opens_at,
      :show_at_the_door_prices_at,
      :mail_payments_end_at, :electronic_payments_end_at,
      :refunds_end_at,
      :shirt_sales_end_at,
      :registration_opens_at,
      :show_on_public_calendar,
      :has_volunteers,
      :location,
      :logo,
      :make_attendees_pay_fees,
      :housing_status, :housing_nights,
      opening_tier: [
        :date, :id
      ],
      opening_tier_attributes: [
        :date, :id
      ]
    )
  end

end
