class HostedEvents::PricingTiersController < ApplicationController
  before_action :set_event
  before_action :set_pricing_tier, only: [:show, :edit, :update, :destroy]

  layout "edit_event"


  # GET /pricing_tiers
  # GET /pricing_tiers.json
  def index
    @pricing_tiers = @event.pricing_tiers
  end

  # GET /pricing_tiers/1
  # GET /pricing_tiers/1.json
  def show
  end

  # GET /pricing_tiers/new
  def new
    @pricing_tier = PricingTier.new
  end

  # GET /pricing_tiers/1/edit
  def edit
  end

  # POST /pricing_tiers
  # POST /pricing_tiers.json
  def create
    @pricing_tier = @event.pricing_tiers.build(pricing_tier_params)
    respond_to do |format|
      if @pricing_tier.save
        format.html { redirect_to hosted_event_pricing_tiers_path(@event.id), notice: 'Pricing tier was successfully created.' }
        format.json { render action: 'show', status: :created, location: @pricing_tier }
      else
        format.html { render action: 'new' }
        format.json { render json: @pricing_tier.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pricing_tiers/1
  # PATCH/PUT /pricing_tiers/1.json
  def update
    respond_to do |format|
      if @pricing_tier.update(pricing_tier_params)
        format.html { redirect_to hosted_event_pricing_tiers_path(@event.id), notice: 'Pricing tier was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @pricing_tier.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pricing_tiers/1
  # DELETE /pricing_tiers/1.json
  def destroy
    @pricing_tier.destroy
    respond_to do |format|
      format.html { redirect_to pricing_tiers_url }
      format.json { head :no_content }
      format.js { }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_pricing_tier
    @pricing_tier = @event.pricing_tiers.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def pricing_tier_params
    params[:pricing_tier].permit(
      :increase_by_dollars, :date, :registrants, package_ids: [])
  end


end
