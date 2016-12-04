AeonVera::Application.routes.draw do
  constraints(Subdomain) do
    match '(*any)' => redirect { |_params, request|
      url = request.url
      new_url = Subdomain.redirect_url_for(url)
    }, via: [:get]
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  # for our frontend ui.
  # this should also enable the creation of
  # native mobile apps for android / iphone / whatever
  namespace :api, defaults: { format: :json } do
    # for both events and communities
    resources :integrations, except: [:update, :index]

    # Various Event information / summaries
    resources :registered_events # personally registured events for current user
    resources :upcoming_events # public calendar
    resources :hosted_events # TODO: Is this used?
    resources :registerable_events # TODO: is this used?
    resources :event_summaries, only: [:show] # overview

    resources :notes
    # organizations / communties
    # TODO: finalize a name for these
    resources :communities # public
    resources :organizations # managing
    resources :organization_summaries, only: [:show] # overview
    resources :lessons
    resources :dances
    resources :restraints, except: [:show]
    resources :members do
      collection do
        get :all
      end
    end
    resources :membership_renewals
    resources :membership_options

    # per event
    # ideally this stuff would be nested under events
    get 'hosts/:subdomain', to: 'hosts#show'
    resources :hosts
    resources :events
    resources :sponsorships

    resources :collaborations, except: [:show]
    resources :housing_requests
    resources :housing_provisions
    resources :volunteers
    resources :housing_stats
    resources :event_attendances do
      member do
        put :checkin
      end
    end
    resources :competitions
    resources :competition_responses
    resources :line_items

    resources :orders do
      member do
        # breaking pure REST :-(
        # it's better than hacking a bunch of if conditionals
        # in the core actions though.
        get :refresh_stripe
        put :refund_payment
        put :mark_paid
      end
    end

    resources :order_line_items do
      member do
        put :mark_as_picked_up
      end
    end
    resources :shirts
    resources :packages
    resources :discounts
    resources :levels
    resources :pricing_tiers
    resources :opening_tiers, controller: :pricing_tiers
    resources :raffles
    resources :raffle_tickets
    resources :raffle_ticket_purchasers
    resources :custom_fields
    resources :custom_field_responses, only: [:update, :index]
    resources :chart_data
    get '/chart_infos/:id', to: 'chart_data#show'
    get '/charts/:id', to: 'chart_data#show'

    devise_scope :api_user do
      get '/confirmation', to: 'users/confirmations#show'
      post '/confirmation', to: 'users/confirmations#create'
    end

    resources :registrations

    get '/users/current-user', to: 'users#show'
    devise_for :users, # skip: :sessions,
      controllers: {
        # password resets
        passwords: 'api/users/passwords',
        # email confirmations
        confirmations: 'api/users/confirmations',
        # creating new account
        registrations: 'api/users/registrations',
        # logging in
        sessions: 'api/users/sessions'
      }

    # accepting invitations to work on an event / org
    put '/users/collaborations', to: 'users/collaborations#update'

    # for new user creation / registration / signing up
    put '/users/', to: 'users#create'
    resources :users, only: [:show, :update, :destroy]
  end

  namespace :oauth do
    resources :stripe
    get 'stripe/authorize', to: 'stripe#authorize'
    post 'stripe/webhook', to: 'stripe#webhook'
  end

  namespace :auth do
    get 'paypal/callback', to: 'paypal#callback'
  end

  # legacy routes
  get '/terms_of_service', to: redirect('welcome/tos')
  get '/privacy', to: redirect('/welcome/privacy')
  get '/calendar', to: redirect('/upcoming-events')
  get '/scenes', to: redirect('/communities')

  # redirect everything to ember
  #
  # But only if it doesn't start with /api/
  # http://www.rubular.com/r/AUxFqYLOf8
  get '/*path' => 'marketing#index', fullpath: /^\/((?!api\/).)*$/
  root to: 'marketing#index'
end
