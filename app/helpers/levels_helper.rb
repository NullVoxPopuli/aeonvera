module LevelsHelper

  def requirement_options
    options_for_select(
      Level::REQUIREMENT_NAMES.map{|k,v| [v, k]}
    )
  end

  def level_menu_options(level)
    dropdown_options(
      links: [
        {
          name: "Edit",
          path: hosted_event_level_path(@event, level)
        },
        {
          name: "Destroy",
          path: hosted_event_level_path(@event, level),
          options: {
            :method => :delete
          }
        }
      ]
    )
  end
end
