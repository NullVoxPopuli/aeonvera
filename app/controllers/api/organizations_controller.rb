class Api::OrganizationsController < Api::ResourceController
  before_filter :must_be_logged_in, except: [:index]

  def index
    # TODO: add a `self.parent = :method` to SkinnyControllers
    if params[:mine]
      organizations = current_user.organizations
      render json: organizations, inclrude: params[:include]
    else
      render json: model, include: params[:include]
    end
  end

  private

  def set_mine
    params[:owner_id] = current_user.id if params[:mine]
  end

  def update_organization_params
    whitelistable_params do |whitelister|
      whitelister.permit(
        :name, :tagline,
        :city, :state, :domain, :make_attendees_pay_fees,
        :logo,
        :logo_file_name, :logo_file_size,
        :logo_updated_at, :logo_content_type
      )
    end
  end

  def create_organization_params
    update_organization_params
  end
end
