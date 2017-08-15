# frozen_string_literal: true

AeonVera::Application.routes.draw do
  require 'sidekiq/web'
  require 'sidekiq-scheduler/web'

  mount Sidekiq::Web => '/sidekiq'

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  # for our frontend ui.
  # this should also enable the creation of
  # native mobile apps for android / iphone / whatever
  namespace :api, defaults: { format: :json } do
    # for both events and communities
    resources :integrations, except: [:update, :index]

    # Various Event information / summaries
    resources :upcoming_events # public calendar
    resources :hosted_events # TODO: Is this used?
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
    resources :membership_discounts

    # per event
    # ideally this stuff would be nested under events
    get 'hosts/:subdomain', to: 'hosts#show'
    resources :hosts
    namespace :events do
      resources :registrations
    end

    resources :events
    resources :sponsorships

    resources :collaborations, except: [:show]
    resources :housing_requests
    resources :housing_provisions
    resources :volunteers
    resources :housing_stats
    # resources :event_attendances do
    #   member do
    #     put :checkin
    #   end
    # end
    resources :competitions
    resources :competition_responses
    resources :line_items

    resources :orders do
      resources :order_line_items
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
      get '/confirmation', to: 'users/devise_overrides/confirmations#show'
      post '/confirmation', to: 'users/devise_overrides/confirmations#create'
    end

    get '/users/current-user', to: 'users#show'
    devise_for :users, # skip: :sessions,
               controllers: {
                 # password resets
                 passwords: 'api/users/devise_overrides/passwords',
                 # email confirmations
                 confirmations: 'api/users/devise_overrides/confirmations',
                 # creating new account
                 registrations: 'api/users/devise_overrides/account_registrations',
                 # logging in
                 sessions: 'api/users/devise_overrides/sessions'
               }

    # accepting invitations to work on an event / org
    put '/users/collaborations', to: 'users/collaborations#update'

    # for new user creation / registration / signing up
    put '/users/', to: 'users#create'

    resources :users, only: [:show, :update, :destroy] do
      collection do
        # personally registured events for current user
        resources :registered_events, controller: 'users/registered_events'
        resources :registrations, controller: 'users/registrations'
      end
    end

    match '*path', to: 'resource#error_route', via: :all
  end

  namespace :oauth do
    resources :stripe
    get 'stripe/authorize', to: 'stripe#authorize'
    post 'stripe/webhook', to: 'stripe#webhook'
  end

  namespace :auth do
    get 'paypal/callback', to: 'paypal#callback'
  end

  # redirect everything to ember
  #
  # But only if it doesn't start with /api/
  # http://www.rubular.com/r/AUxFqYLOf8
  get '/*path' => 'ember#index', fullpath: /^\/((?!api\/).)*$/
  root to: 'ember#index'
end
