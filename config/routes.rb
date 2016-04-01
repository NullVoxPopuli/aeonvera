AeonVera::Application.routes.draw do

  # for our frontend ui.
  # this should also enable the creation of
  # native mobile apps for android / iphone / whatever
  namespace :api, defaults: { format: :json } do
    devise_for :users,# skip: :sessions,
      controllers: {
        # password resets
        passwords: 'api/users/passwords',
        # email confirmations
        confirmations: "confirmations",
        # creating new account
        registrations: "api/users/registrations",
        # logging in
        sessions: "api/users/sessions"
      }

    # for both events and communities
    resources :integrations

    # Various Event information / summaries
    resources :registered_events # personally registured events for current user
    resources :upcoming_events # public calendar
    resources :hosted_events # TODO: Is this used?
    resources :registerable_events # TODO: is this used?
    resources :event_summaries, only: [:show] # overview

    # organizations / communties
    # TODO: finalize a name for these
    resources :communities # public
    resources :organizations # managing
    resources :organization_summaries, only: [:show] # overview
    resources :organization_attendances
    resources :lessons
    resources :dances
    resources :restraints, except: [:show]
    resources :members # list of users
    resources :membership_renewals
    resources :membership_options

    # per event
    # ideally this stuff would be nested under events
    resources :hosts
    resources :housing_requests
    resources :housing_provisions
    resources :volunteers
    resources :housing_stats
    resources :event_attendances
    resources :competitions
    resources :competition_responses
    resources :line_items
    resources :order_line_items
    resources :shirts
    resources :packages
    resources :discounts
    resources :levels
    resources :pricing_tiers
    resources :raffles
    resources :raffle_tickets
    resources :raffle_ticket_purchasers
    resources :custom_fields
    resources :chart_data
    get '/chart_infos/:id', to: 'chart_data#show'
    get '/charts/:id', to: 'chart_data#show'

    # TODO: make the above under events
    resources :events do
      resources :orders, controller: 'events/orders'
      # resources :discounts, controller: 'events/discounts'
      # resources :packages, controller: 'events/packages'
    end

    # user specific info
    resources :orders, except: [:destroy] do
      member do
        put :modify
      end
    end
    resources :registrations

    # for new user creation / registration / signing up
    put '/users/', to: 'users#create'
    resources :users, only: [:show, :update, :destroy]
  end

  namespace :oauth do
    resources :stripe
    get 'stripe/authorize', to: 'stripe#authorize'
    post 'stripe/webhook', to: 'stripe#webhook'
  end

  resources :orders do
    collection do
      get :paid
      get :cancelled
      get :cancel
      get :ipn
    end
  end


  get 'users' => redirect("/")

  resources :payments
  devise_for :users
  devise_scope :user do
    resources :confirmations # confirming email
  end


  namespace :auth do
    get "paypal/callback", to: "paypal#callback"
  end


  # legacy routes
  get "/terms_of_service", to: redirect("welcome/tos")
  get "/privacy", to: redirect("/welcome/privacy")
  get "/calendar", to: redirect("/upcoming-events")
  get "/scenes", to: redirect("/communities")


  # redirect everything to ember
  get "/*path" => "marketing#index"
  root :to => "marketing#index"
end
