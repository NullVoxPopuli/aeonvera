module Api
  class LessonsController < Api::ResourceController
    # self.model_class = LineItem::Lesson
    # self.model_key = :lesson

    before_filter :must_be_logged_in, except: [:index, :show]

    def index
      model = operation_class.new(current_user, params, index_params).run
      render json: model, include: params[:include], each_serializer: LessonSerializer
    end

    def show
      model = operation_class.new(current_user, params, params).run
      render json: model, include: params[:include], serializer: LessonSerializer
    end

    private

    def index_params
      params[:filter] ? params : params.require(:organization_id)
    end

    def update_lesson_params
      whitelistable_params do |whitelister|
        whitelister.permit(
          :name, :price, :description,
          :starts_at, :ends_at, :expires_at,
          :registration_opens_at, :registration_closes_at, :becomes_available_at, :membership_discount_id
        )
      end
    end

    def create_lesson_params
      whitelistable_params(polymorphic: [:host]) do |whitelister|
        whitelister.permit(
          :host_id, :host_type,
          :name, :price, :description,
          :starts_at, :ends_at, :expires_at,
          :registration_opens_at, :registration_closes_at, :becomes_available_at, :membership_discount_id
        )
      end
    end
  end
end
