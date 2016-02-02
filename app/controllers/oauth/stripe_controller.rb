class Oauth::StripeController < OauthController
  include OrganizationLoader

  before_action :map_stripe_state_param_to_payable, only: [:authorize]
  before_action :set_payable, only: [:new, :authorize, :destroy]

  # redirect to stripe
  def new
    redirect_to self.authorize_url
  end

  # post to get access code
  def authorize
    data = self.identify
    # store access code in integration
    @payable.integrations[Integration::STRIPE] = data

    flash[:notice] = "Stripe has been successfully connected. You may now begin taking payments."
    if @payable.is_a?(Event)
      redirect_to "/events/#{@payable.id}/edit/payment-processors"
      # redirect_to hosted_event_payment_processors_path(@payable)
    else
      redirect_to organization_payment_processors_path(@payable)
    end
  end

  def destroy
    integration = @payable.integrations[Integration::STRIPE]
    if integration && integration.destroy
      flash[:notice] = "Stripe has been removed."
    end

    if @payable.is_a?(Event)
      redirect_to hosted_event_payment_processors_path(@payable)
    else
      redirect_to organization_payment_processors_path(@payable)
    end
  end

  def connected

  end

  def webhook

  end

  protected

  def access_token_url
    STRIPE_CONFIG['access_token_url']
  end

  def authorize_url
    state = "#{@payable.class.name}-#{@payable.id}"
    return_url = oauth_stripe_authorize_url(payable_id: @payable.id, payable_type: @payable.class.name)

    url = STRIPE_CONFIG['authorize_url']
    url += "?client_id=#{client_id}"
    url += "&response_type=code"
    url += "&return_url=#{return_url}"
    url += "&state=#{state}"
    url += "&scope=read_write"
    url
  end

  private

  def set_payable
    if params[:payable_type] == "Event"
      set_event(id: params[:payable_id])
      @payable = @event
    elsif params[:payable_type] == "Organization"
      set_organization(id: params[:payable_id])
      @payable = @organization
    end
  end

  def client_id
    ENV['STRIPE_CLIENT_ID'] || STRIPE_CONFIG['client_id']
  end

  def client_secret
    ENV['STRIPE_SECRET_KEY'] || STRIPE_CONFIG['secret_key']
  end

  def map_stripe_state_param_to_payable
    payable_parts = params[:state].split('-')
    params[:payable_type] = payable_parts[0]
    params[:payable_id] = payable_parts[1]
  end

end
