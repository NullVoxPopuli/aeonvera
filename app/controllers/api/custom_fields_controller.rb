class Api::CustomFieldsController < Api::EventResourceController
  private

  def update_custom_field_params
    params
      .require(:data)
      .require(:attributes)
      .permit(:label, :kind, :default_value, :editable)
  end

  def create_custom_field_params
    create_params_with(update_custom_field_params, host: true)
  end
end
