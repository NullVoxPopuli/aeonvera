class Api::LessonsController < Api::EventResourceController
  self.model_class = LineItem::Lesson

  def index
    model = operation_class.new(current_user, params, index_params).run
    render json: model, include: params[:include], each_serializer: LineItem::LessonSerializer
  end

  def show
    model = operation_class.new(current_user, params, show_params).run
    render json: model, include: params[:include], serializer: LineItem::LessonSerializer
  end

  private

  def index_params
    params[:filter] ? params : params.require(:organization_id)
  end

  def update_line_item_params
    params
      .require(:data)
      .require(:attributes)
      .permit(:name, :price)
    end

  def create_line_item_params
    create_params_with(update_line_item_params, host: true)
  end
end
