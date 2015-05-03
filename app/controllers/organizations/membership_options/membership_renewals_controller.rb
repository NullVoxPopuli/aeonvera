class Organizations::MembershipOptions::MembershipRenewalsController < ApplicationController
  include OrganizationLoader
  include MembershipOptionLoader

  before_action :set_organization
  before_action :set_membership_option

  layout "edit_organization"

  def non_members
    @search = User.ransack(params[:q])
    @non_members = @search.result - @membership_option.members
    respond_to do |format|
      format.json{
        render json: @non_members.to_json(only: [:id, :first_name, :last_name])
      }
    end
  end

  def new
    @renewal = MembershipRenewal.new
  end

  def create
    @renewal = @membership_option.renewals.new(renewal_params)

    respond_to do |format|
      if @renewal.save!
        format.html {
          flash[:notice] = "Membership Renewed"
          redirect_to organization_membership_option_members_path(@organization, @membership_option)
        }
      else
        format.html {
          render action: 'new'
        }
      end
    end
  end



  private

  def renewal_params
    params[:membership_renewal].permit(
      :start_date, :user_id
    )
  end
end
