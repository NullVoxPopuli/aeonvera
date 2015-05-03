class HostedEvents::DiscountsController < ApplicationController
  before_action :set_event
  before_action :set_discount, only: [:show, :edit, :update, :destroy]

  layout "edit_event"

  # GET /discounts
  # GET /discounts.json
  def index
    @discounts = @event.discounts
  end

  # GET /discounts/1
  # GET /discounts/1.json
  def show
  end

  # GET /discounts/new
  def new
    @discount = Discount.new
  end

  # GET /discounts/1/edit
  def edit
  end

  # POST /discounts
  # POST /discounts.json
  def create
    @discount = @event.discounts.new(discount_params)
    respond_to do |format|
      if @discount.save!
        format.html { redirect_to hosted_event_discounts_path(@event.id), notice: 'Discount was successfully created.' }
        format.json { render action: 'show', status: :created, location: @discount }
      else
        format.html { render action: 'new' }
        format.json { render json: @discount.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /discounts/1
  # PATCH/PUT /discounts/1.json
  def update
    respond_to do |format|
      if @discount.update(discount_params)
        format.html { redirect_to hosted_event_discount_path(@event, @discount), notice: 'Discount was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @discount.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /discounts/1
  # DELETE /discounts/1.json
  def destroy
    @discount.destroy
    respond_to do |format|
      format.html { redirect_to hosted_event_discounts_path }
      format.json { head :no_content }
    end
  end

  def disable

  end

  def enable

  end

  private
  # Use callbacks to share common setup or constraints between actions.

  def set_discount
    @discount = Discount.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def discount_params
    params[:discount].permit(
        :value, :name, :kind, :affects, :allowed_number_of_uses
      )
  end
end
