class OrganizationsController < ApplicationController
  include SetsOrganization
  skip_before_action :set_organization, only: [:index, :new, :create]

  def index
    @organizations = current_user.organizations
    @collaborated_organizations = current_user.collaborated_organizations
    @all_organizations = [@organizations, @collaborated_organizations].flatten
    @public_organizations = Organization.all
  end

  def show
    @total_members = @organization.membership_options.map{|membership|
      membership.members.count
    }.inject(:+) || 0

    render layout: 'layouts/edit_organization'
  end

  def new
    @organization = Organization.new
  end

  def edit
    render layout: 'layouts/edit_organization'
  end

  def create
    @organization = Organization.new(organization_params)
    @organization.owner = current_user

    respond_to do |format|
      if @organization.save
        format.html { redirect_to organizations_path(@organization), notice: 'Organization was successfully created.' }
        format.json { render action: 'show', status: :created, location: @organization }
      else
        format.html { render action: 'new', layout: "application" }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @organization.update(organization_params)
        format.html { redirect_to organization_path(@organization), notice: 'Organization was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @organization.soft_delete!
    respond_to do |format|
      format.html { redirect_to organization_url }
      format.json { head :no_content }
      format.js { }
    end
  end

  def un_destroy
    @organization = current_user.organizations.with_deleted.find(params[:id])

    @organization.soft_undelete!
    respond_to do |format|
      format.html { redirect_to organization_url }
      format.json { head :no_content }
      format.js { }
    end
  end

  private

  def organization_params

    params[:organization].permit(
      :name,
      :tagline,
      :logo,
      :city,
      :state,
      :domain
    )
  end

end
