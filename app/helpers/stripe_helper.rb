module StripeHelper

  def stripe_publishable_key
    ENV['STRIPE_PUBLISHABLE_KEY'] || STRIPE_CONFIG["publishable_key"]
  end

  # @note must use GET request
  # @param [ActiveRecord::Base] payable id of payable
  # @return [String] path to creat stripe connection for the selected event
  def stripe_connect_path(payable: @payable)
    oauth_stripe_new_path(
      payable_id: payable.id,
      payable_type: payable.class.name
    )
  end

  # @note must use DELETE request
  # @param [ActiveRecord::Base] payable id of payable
  # @return [String] path to remove stripe connection for the selected event
  def stripe_disconnect_path(payable: @payable)
    oauth_stripe_path(
      payable_id: payable.id,
      payable_type: payable.class.name
    )
  end

  # https://stripe.com/docs/connect/reference
  def stripe_connect_button(payable: @payable)
    link_to(
      stripe_connect_path(payable: payable),
      :class => "stripe-connect light-blue"
    ) do
      content_tag(:span, "Connect With Stripe")
    end
  end

  def stripe_disconnect_button(payable: @payable)
    link_to(
      stripe_disconnect_path(payable: payable),
      :class => 'stripe-connect light-blue',
      method: :delete
    ) do
      content_tag(:span, "Remove Connection with Stripe")
    end
  end

  def payable_object
    (
      @payable ||
      @event ||
      @organization ||
      try(:current_event) ||
      try(:current_organization)
    )
  end

  def stripe_checkout_script(description, total, email: current_user.email, label: nil)
    payable = payable_object
    key = payable.integrations[Integration::STRIPE].config[:stripe_publishable_key]

    options = {
      :src => "https://checkout.stripe.com/checkout.js",
      :class => "stripe-button",
      "data-key" => key,
      "data-name" => APPLICATION_CONFIG['app_name'],
      "data-description" => "#{description}",
      "data-email" => email,
      "data-amount" => (total * 100).to_i, # in cents
      "data-allow-remember-me" => false
    }

    if payable.logo.present?
      options["data-image"] = payable.logo.url(:medium)
    end

    if label
      options["data-label"] = label
    end

    content_tag(:script, "", options)
  end

  def what_is_stripe_tooltip
    content_tag(
      :span,
      "data-tooltip" => true,
      "aria-haspopup" => true,
      "class" => "has-tip",
      "title" => "Stripe is a company and service that (similar to PayPal)
                  provides a way for individuals and businesses to accept
                  online payments."
    ) do
      "What is Stripe?"
    end
  end

  def what_is_this_stripe_fee_tooltip(text = "Fees")
        content_tag(
      :span,
      "data-tooltip" => true,
      "aria-haspopup" => true,
      "class" => "has-tip",
      "title" => "This amount is the combination of the Stripe fee
                  (2.9% + 30¢) and the #{APPLICATION_CONFIG["app_name"]}
                  fee (0.75%) based on the total amount the registrant
                  paid. It is not included in any revenue totals,
                  as you only care about how much money you receive
                  (Net Received)."
    ) do
      text
    end
  end


end
