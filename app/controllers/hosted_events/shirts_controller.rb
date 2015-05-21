class HostedEvents::ShirtsController < ApplicationController
  include SetsEvent
  layout "edit_event"

  before_action :set_shirt, only: [:show, :edit, :update, :destroy]

  # GET /shirts
  # GET /shirts.json
  def index
    @shirts = @event.shirts
  end

  # GET /shirts/1
  # GET /shirts/1.json
  def show
  end

  # GET /shirts/new
  def new
    @shirt = LineItem::Shirt.new
  end

  # GET /shirts/1/edit
  def edit
  end

  # POST /shirts
  # POST /shirts.json
  def create
    @shirt = @event.shirts.build(shirt_params)

    respond_to do |format|
      if @shirt.save
        format.html { redirect_to hosted_event_shirts_path(@event.id), notice: 'Shirt was successfully created.' }
        format.json { render action: 'show', status: :created, location: @shirt }
      else
        format.html { render action: 'new' }
        format.json { render json: @shirt.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shirts/1
  # PATCH/PUT /shirts/1.json
  def update
    respond_to do |format|
      if @shirt.update(shirt_params)
        format.html { redirect_to hosted_event_shirts_path(@event.id), notice: 'Shirt was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @shirt.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shirts/1
  # DELETE /shirts/1.json
  def destroy
    @shirt.destroy
    respond_to do |format|
      format.html { redirect_to hosted_event_shirts_path }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_shirt
    @shirt = @event.shirts.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def shirt_params
    if s = params[:line_item_shirt]
      if m = s[:metadata]
        if sz = m[:sizes]
          sz.compact!
        end
      end
    end

    params[:line_item_shirt].permit(
      :name,
      :price,
      :picture,
      metadata: {
        sizes: [],
        prices: LineItem::Shirt::ALL_SIZES
      }
    )
  end
end
