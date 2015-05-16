module LevelsHelper

  def requirement_options(level = nil)
    args = []
    args << Level::REQUIREMENT_NAMES.map{|k,v| [v, k]}
    args << level.requirement if level.present?
    options_for_select(*args)
  end

  def level_menu_options(level)
    dropdown_option_menu_for(level, actions: [:edit, :destroy])
  end
end
