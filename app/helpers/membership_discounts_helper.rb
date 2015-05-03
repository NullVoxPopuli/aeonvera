module MembershipDiscountsHelper

  def membership_discount_menu_options(d)
    dropdown_options(
      links: [
        {
          name: "Edit",
          path: edit_organization_membership_discount_path(@organization, d)
        },
        {
          name: "Destroy",
          path: organization_membership_discount_path(@organization, d),
          options: {
            :method => :delete
          }
        }
      ]
    )
  end

  def membership_discounts_affects_options
    {
      "Dances" => LineItem::Dance.name,
      "Lessons" => LineItem::Lesson.name
    }
  end

end
