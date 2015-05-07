class Organizations::LessonsController < ApplicationController
  include OrganizationLoader
  before_action :set_organization

  layout "edit_organization"


  def index
    @lessons = @organization.lessons.all
  end

  def show
    @lesson = @organization.lessons.find(params[:id])

    user_proxy =  User.joins(
      orders: :line_items
    ).where(
      'order_line_items.line_item_id' => @lesson.id,
      'order_line_items.line_item_type' => @lesson.class.name,
      'orders.paid' => true)

    @users = user_proxy.all.uniq
    @counts = user_proxy.group(:user_id).count
  end

  def duplicate
    @old_lesson = @organization.lessons.find(params[:id])

    @lesson = @organization.lessons.new(@old_lesson.duplicatable_attributes)
    @lesson.name = "Copy of #{@old_lesson.name}"

    respond_to do |format|
      if @lesson.save
        format.html {
          flash[:notice] = "Lesson duplicated"
          redirect_to action: :edit, id: @lesson.id
        }
      else
        format.html {
          flash[:notice] = "Lesson not duplicated"

          render action: 'edit'
        }
      end
    end
  end

  def new
    @lesson = LineItem::Lesson.new
  end

  def edit
    @lesson = @organization.lessons.find(params[:id])
  end

  def update
    @lesson = @organization.lessons.find(params[:id])

    respond_to do |format|
      if @lesson.update(lesson_params)
        format.html {
          redirect_to action: :index, notice: "Lesson was successfully updated"
        }
      else
        format.html {
          render action: 'edit'
        }
      end
    end
  end

  def create
    @lesson = @organization.lessons.new(lesson_params)

    respond_to do |format|
      if @lesson.save
        format.html {
          flash[:notice] = "Lesson created"
          redirect_to action: :index
        }
      else
        format.html {
          render action: 'edit'
        }
      end
    end
  end

  private

  def lesson_params
    params[:lesson].permit(
      :name, :description,
      :price, :lesson_price,
      :starts_at, :ends_at,
      :registration_opens_at,
      :registration_closes_at,
      :schedule
    )
  end
end
