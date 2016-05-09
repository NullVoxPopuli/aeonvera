class Api::LessonsController < Api::EventResourceController
  self.model_class = LineItem::Lesson
  self.model_key = :lesson

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

  def update_lesson_params
    whitelistable_params do |whitelister|
      whitelister.permit(:name, :price)
    end
  end

  def create_lesson_params
    whitelistable_params(polymorphic: [:host]) do |whitelister|
      whitelister.permit(:name, :price, :host_id, :host_type)
    end
  end
end
