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

  def field_for_custom_field(custom_field)
    id = "custom_field_responses_#{custom_field.id}"
    name = "custom_field_responses[][value]"
    default_value = custom_field.default_value

    hidden_field_tag("custom_field_responses[][custom_field_id]", custom_field.id) +
    if custom_field.editable?
      case custom_field.kind
        when CustomField::KIND_TEXT
          text_field_tag name, nil, placeholder: default_value
        when CustomField::KIND_FORMATTED_TEXT
          text_area_tag name, default_value
        when CustomField::KIND_NUMBER
          number_field_tag name, nil, placeholder: default_value
        # when CustomField::KIND_DATE
        # when CustomField::KIND_TIME
        # when CustomField::KIND_DATETIME
        when CustomField::KIND_CHECKBOX
          check_box_tag name, '1', false
        # when CustomField::KIND_RADIO
        # when CustomField::KIND_RANGE
        # when CustomField::KIND_PHONE
      end
    else
      custom_field.default_value.html_safe
    end
  end

end
