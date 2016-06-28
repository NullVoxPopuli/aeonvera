class Api::ResourceController < APIController
  include SkinnyControllers::Diet

  def index
    respond_to do |format|
      format.json { render_models }
    end
  end

  def show
    render json: model, include: params[:include]
  end

  def create
    render_model(params[:include], success_status: 201)
  end

  def update
    render_model
  end

  def destroy
    render_model
  end
end
