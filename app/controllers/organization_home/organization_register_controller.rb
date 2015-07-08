class OrganizationHome::OrganizationRegisterController < ApplicationController
  include CurrentSubdomain
  include CurrentOrganization

  layout 'organization_home'

  before_filter :current_organization
  helper_method :current_organization

  before_action :set_attendance, except: [ :new, :create, :index ]

  def index
    @attendances = current_organization.attendances.where(
      attendee: current_user
    )
  end

  def show

  end

  def edit

  end

  def new
    @attendance = OrganizationAttendance.new
  end

  def create
    @attendance = current_organization.attendances.new(attendance_params)
    @attendance.attendee = current_user

    respond_to do |format|
      format.html {
        if @attendance.save
          order = @attendance.create_order(
            payment_method: Payable::Methods::STRIPE
          )

          AttendanceMailer.thankyou_email(order: order).deliver_now

        else
          return render action: "new"
        end

      }
    end

  end

  def update
    respond_to do |format|

      if @attendance.update(attendance_params)

        @attendance.orders.destroy_all
        order = @attendance.create_order

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

  def destroy
    if @attendance and @attendance.owes_money?
      @attendance.destroy
      flash[:notice] = "Deleted"
      redirect_to action: "index"
    else
      flash[:notice] = "This has already been paid for"
      redirect_to action: "show"
    end
  end

  private

  def set_attendance
    begin
      @attendance = current_user.attendances.find(params[:id])
    rescue => e
      redirect_to root_url, notice: "Attendance Not Found"
    end
  end

  def attendance_params
    params[:attendance].permit(
        metadata: [
          line_items: {
            id: [
              :quantity
            ]
          }
        ],
        line_item_ids: []
    ).tap do |whitelisted|
      if line_items = params[:attendance].try(:[], :metadata).try(:[], :line_item)
        whitelisted[:metadata][:line_items] = line_items
        whitelisted[:line_item_ids] ||= []
        # make sure that any of the quantities are > 0
        add_to_line_items = false
        line_items.each{|item_id, line_item_data|
          line_item_data.each{ |property, value|
            if value && value.to_i > 0
              whitelisted[:line_item_ids] << item_id
            end
          }
        }
      end
    end
  end
end
