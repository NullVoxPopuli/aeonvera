class CustomFieldDecorator < Draper::Decorator
  delegate_all


  KIND_NAMES = {
    CustomField::KIND_TEXT => "Text",
    CustomField::KIND_FORMATTED_TEXT => "Formatted Text",
    CustomField::KIND_NUMBER => "Number",
    # CustomField::KIND_DATE => "Date",
    # CustomField::KIND_TIME => "Time",
    # CustomField::KIND_DATETIME => "DateTime",
    CustomField::KIND_CHECKBOX => "Checkbox"
    # CustomField::KIND_RADIO => "Radio",
    # CustomField::KIND_RANGE => "Range",
    # CustomField::KIND_PHONE => "Phone Number"
  }

  def kind_name
    KIND_NAMES[object.kind]
  end


end
