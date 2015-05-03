class Organizations::MembershipOptionsController < ApplicationController
  include OrganizationLoader
  before_action :set_organization

  layout "edit_organization"


  def index
    @membership_options = @organization.membership_options
  end


  def new
    @membership_option = LineItem::MembershipOption.new
  end

  def edit
    @membership_option = @organization.membership_options.find(params[:id])
  end

  def update
    @membership_option = @organization.membership_options.find(params[:id])

    respond_to do |format|
      if @membership_option.update(membership_params)
        format.html {
          redirect_to action: :index, notice: "Membership was successfully updated"
        }
      else
        format.html {
          render action: 'edit'
        }
      end
    end
  end

  def create
    @membership_option = @organization.membership_options.new(membership_params)

    respond_to do |format|
      if @membership_option.save!
        format.html {
          flash[:notice] = "Membership option created"
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

  def membership_params
    params[:membership_option].permit(
      :name,
      :description,
      :duration_amount,
      :duration_unit,
      :price
    )
  end
end
