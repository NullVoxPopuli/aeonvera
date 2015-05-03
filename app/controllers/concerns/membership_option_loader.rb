module MembershipOptionLoader

  def set_membership_option(id: nil)
    id = (id or params[:membership_option_id] or params[:id])
    @membership_option = @organization.membership_options.find_by_id(id)

    unless @membership_option
      flash[:alert] = "Membership Option Not Found"
      redirect_to organization_path(@organization)
    end
  end

end
