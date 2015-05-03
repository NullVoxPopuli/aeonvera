class Organizations::DancesController < ApplicationController
  include OrganizationLoader

  before_action :set_organization

  layout "edit_organization"


  def index
    @dances = @organization.dances.all
  end


  def new
    @dance = LineItem::Dance.new
  end

  def edit
    @dance = @organization.dances.find(params[:id])
  end

  def update
    @dance = @organization.dances.find(params[:id])

    respond_to do |format|
      if @dance.update(dance_params)
        format.html {
          redirect_to action: :index, notice: "Dance was successfully updated"
        }
      else
        format.html {
          render action: 'edit'
        }
      end
    end
  end

  def create
    @dance = @organization.dances.new(dance_params)

    respond_to do |format|
      if @dance.save!
        format.html {
          flash[:notice] = "Dance created"
          redirect_to action: :index
        }
      else
        format.html {
          render action: 'edit'
        }
      end
    end
  end

  private

  def dance_params
    params[:dance].permit(
      :name, :description,
      :price, :lesson_price,
      :starts_at, :ends_at,
      :registration_opens_at,
      :registration_closes_at,
      :schedule
    )
  end
end
