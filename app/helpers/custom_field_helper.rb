module CustomFieldHelper

  def custom_field_kind_options
    options_for_select(
      custom_field_kind_select_options
    )
  end

  def custom_field_kind_select_options
    CustomFieldDecorator::KIND_NAMES.map{ |k, v| [v, k] }
  end

  def custom_field_menu_options(custom_field)
    dropdown_option_menu_for(custom_field, actions: [:edit, :destroy])
  end

end
