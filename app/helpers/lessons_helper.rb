module LessonsHelper
  def lesson_menu_options(lesson)
    dropdown_options(
      links: [
        {
          name: "Edit",
          path: edit_organization_lesson_path(@organization, lesson)
        },
        {
          name: "Destroy",
          path: organization_lesson_path(@organization, lesson),
          options: {
            method: :delete,
            confirm: "Are you sure?"
          }
        }
      ]
    )
  end
end
