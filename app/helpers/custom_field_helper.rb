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

  def field_for_custom_field(custom_field, form, value = nil)
    default_value = custom_field.default_value

    value_field = (
      if custom_field.editable?
        case custom_field.kind
          when CustomField::KIND_TEXT
            form.text_field :value, value: value, placeholder: default_value
          when CustomField::KIND_FORMATTED_TEXT
            form.text_area custom_field.id, value: nil
          when CustomField::KIND_NUMBER
            form.number_field :value, value: value, placeholder: default_value
          # when CustomField::KIND_DATE
          # when CustomField::KIND_TIME
          # when CustomField::KIND_DATETIME
          when CustomField::KIND_CHECKBOX
            form.check_box :value, value: value
          # when CustomField::KIND_RADIO
          # when CustomField::KIND_RANGE
          # when CustomField::KIND_PHONE
        end
      else
        custom_field.default_value.html_safe
      end
    )

    value_field
  end

end
