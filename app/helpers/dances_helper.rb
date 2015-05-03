module DancesHelper
  def dance_menu_options(dance)
    dropdown_options(
      links: [
        {
          name: "Edit",
          path: edit_organization_dance_path(@organization, dance)
        },
        {
          name: "Destroy",
          path: organization_dance_path(@organization, dance),
          options: {
            method: :delete,
            confirm: "Are you sure?"
          }
        }
      ]
    )
  end
end
