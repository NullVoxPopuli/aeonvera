module MembershipOptionsHelper

  def membership_option_menu_options(membership_option)
    dropdown_options(
      links: [
        {
          name: "Edit",
          path: edit_organization_membership_option_path(@organization, membership_option)
        },
        {
          name: "Destroy",
          path: organization_membership_option_path(@organization, membership_option),
          options: {
            method: :delete,
            confirm: "Are you sure?"
          }
        }
      ]
    )
  end
  
end
