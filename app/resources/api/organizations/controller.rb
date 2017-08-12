# frozen_string_literal: true

module Api
  class OrganizationsController < Api::ResourceController
    self.serializer = OrganizationSerializableResource
    self.default_fields = {
      organization: [
        :name, :tagline,
        :city, :state, :beta,
        :domain,
        :logo_file_name, :logo_content_type,
        :logo_file_size, :logo_updated_at,
        :make_attendees_pay_fees,
        :notify_email,
        :email_all_purchases,
        :email_membership_purchases,
        :contact_email
      ]
    }

    before_filter :must_be_logged_in, except: [:index, :show]

    def index
      # TODO: add a `self.parent = :method` to SkinnyControllers
      if params[:mine]
        organizations = current_user.owned_and_collaborated_organizations

        render_jsonapi(model: organizations)
      else
        render_jsonapi
      end
    end

    def show
      presented = OrganizationPresenter.new(model)

      render_jsonapi(model: presented)
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
          :logo_updated_at, :logo_content_type,
          :notify_email,
          :email_all_purchases,
          :email_membership_purchases,
          :contact_email
        )
      end
    end

    def create_organization_params
      update_organization_params
    end
  end
end
