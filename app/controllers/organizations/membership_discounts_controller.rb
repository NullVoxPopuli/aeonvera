class Organizations::MembershipDiscountsController < ApplicationController
  include OrganizationLoader
  before_action :set_organization
  before_action :set_membership_discount, only: [:show, :edit, :update, :destroy]

  layout "edit_organization"

  def index
    @membership_discounts = @organization.membership_discounts
  end

  def new
    @membership_discount = MembershipDiscount.new
  end

  def edit
  end

  def update
    respond_to do |format|
      if @membership_discount.update(membership_discount_params)
        format.html {
          redirect_to action: :index, notice: "Discount was successfully updated"
        }
      else
        format.html {
          render action: 'edit'
        }
      end
    end
  end

  def create
    @membership_discount = @organization.membership_discounts.new(membership_discount_params)

    respond_to do |format|
      if @membership_discount.save!
        format.html {
          flash[:notice] = "Discount option created"
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


  def set_membership_discount
    @membership_discount = @organization.membership_discounts.find(params[:id])
  end

  def membership_discount_params
    params[:membership_discount].permit(
        :value, :name, :kind, :affects, :allowed_number_of_uses
      )
  end


end
