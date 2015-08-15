class HostedEvents::AttendancesController < ApplicationController

  include SetsEvent
  include MarkPaid

  before_action :set_attendance, only: [:mark_paid, :edit, :update, :destroy, :resend_receipt, :transfer]

  layout "hosted_events"

  def index
    @attendances = @event.attendances

    respond_to do |format|
      format.html{}
      format.csv{
        send_data @attendances.to_csv
      }
    end
  end

  def transfer
    @attendance.assign_attributes(transfer_params)
    @attendance.transferred_at = Time.now

    respond_to do |format|
      if @attendance.save
        format.html { redirect_to hosted_event_attendance_path(@event, @attendance), notice: 'Transfer successful!.' }
        format.json { head :no_content }
      else
        format.html { render action: 'show', notice: 'Transfer failed' }
        format.json { render json: @attendance.errors, status: :unprocessable_entity }
      end
    end
  end

  def unpaid
    @attendances = @event.attendances.unpaid

    respond_to do |format|
      format.html{}
      format.csv{
        send_data @attendances.to_csv
      }
    end
  end

  def resend_receipt
    @order = @attendance.orders.find(params[:order_id])

    if @order
      AttendanceMailer.payment_received_email(order: @order).deliver_now
    end

    flash[:notice] = "Receipt Sent"
    redirect_to action: "show", id: @attendance.id
  end

  def print_checkin
    @attendances = @event.attendances.joins(:attendee).reorder('users.last_name, users.first_name')
  end


  def show
    @attendance = @event.all_attendances.find(params[:id])
  end

  def new
    @attendance = EventAttendance.new
    @user = User.new
  end

  def edit
    @attendance = @event.attendances.find(params[:id])
  end

  def create
    userless = user_params[:email].blank?
    if userless
      # don't create a user if we don't have an emailsss
    else
      @user = User.new(user_params.merge(
                         password: 'changeme',
                         password_confirmation: 'changeme'
      ))
    end

    @attendance = EventAttendance.new(attendance_params)
    if userless
      @attendance.metadata["first_name"] = user_params[:first_name]
      @attendance.metadata["last_name"] = user_params[:last_name]
    else
      @attendance.attendee = @user
    end
    @attendance.pricing_tier = @event.current_tier
    @attendance.event = @event

    # checkIN
    @attendance.checkin!

    valid = true
    valid &= @user.valid? if not userless
    valid &= @attendance.valid?

    # only save both if both are valid
    if valid
      @user.save if not userless
      @attendance.save
    end

    respond_to do |format|
      if valid
        format.html { redirect_to hosted_event_checkin_index_path(@event), notice: "#{@attendance.attendee_name} has been successfully registered" }
        format.json { render action: 'show', status: :created, location: @attendance }
      else
        format.html { render action: 'new' }
        format.json { render json: @attendance.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @attendance.update(attendance_params)
        format.html { redirect_to [@event, @attendance], notice: 'Attendance was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @attendance.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @attendance.attending = false
    @attendance.save
    respond_to do |format|
      format.html {
        flash[:notice] = "#{@attendance.attendee_name} is marked as not attending anymore."
        redirect_to hosted_event_cancelled_attendances_path(@event)
      }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.

  def set_attendance
    @attendance = @event.attendances.find(params[:id])
  end

  def user_params
    params[:attendance][:attendee].permit(
      :first_name,
      :last_name,
      :email
    )
  end

  def transfer_params
    params[:attendance].permit(
      :transferred_to_name,
      :transfer_reason,
      :dance_orientation
    )
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def attendance_params
    params[:attendance].permit(
      :package_id, :level_id,
      :pricing_tier_id,
      :dance_orientation,
      # attendee: [
      #   :first_name,
      #   :last_name,
      #   :email
      # ],
      metadata: [
        :first_name,
        :last_name,
        :email,
        address: [
          :line1, :line2,
          :city, :state,
          :zip
        ]
      ],
      competition_ids: [],
      line_item_ids: []
    )
  end



end
