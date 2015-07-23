AeonVera::Application.routes.draw do

  namespace :api, defaults: {format: :json} do
    resources :attended_events
    resources :upcoming_events
    resources :hosted_events
    resources :registerable_events

    resources :communities

    resources :housing_requests

    resources :attendances

    # manually define routes for the current user
    get 'user', to: 'user#show'
    patch 'user', to: 'user#update'
    put 'user', to: 'user#update'
    delete 'user', to: 'user#destroy'
  end


  resources :dances

  constraints(AdminSubdomain) do
    namespace :admin, path: "/" do
      post '/auth/admin/callback', :to => 'sessions#authenticate'
      get '/auth/failure', :to => 'sessions#failure'

      resources :users do
        member do
          get :assume_control
        end
      end

      resources :money

      resources :events do
        member do
          get :toggle_beta
        end
      end

      root to: "money#index"
    end
  end

  namespace :oauth do
    get 'stripe/new', to: "stripe#new"
    get 'stripe/authorize', to: 'stripe#authorize'
    post 'stripe/webhook', to: 'stripe#webhook'
    delete 'stripe/', to: 'stripe#destroy'
  end

  resources :orders do
    collection do
      get :paid
      get :cancelled
      get :cancel
      get :ipn
    end
  end



  get "/register/:id/register", to: "register#register"

  # route all requests with a subdomain to  controller
  constraints(Subdomain) do

    constraints(SubdomainBelongsToOrganization) do

      resources :classes#, controller: "organizations/classes"
      resources :dances#, controller: "organizations/dances"
      resources :membership
      resources :register, controller: "organization_home/organization_register"
      resources :payments, controller: "payments"


      get "/", to: 'organization_home#index'
    end

    constraints(SubdomainBelongsToEvent) do

      resources :payments, controller: "payments"


      resources :orders do
        collection do
          get :paid
          get :cancelled
          get :cancel
          get :ipn
        end
      end


      resources :register do
        collection do
          get :countdown
          get :confirm
        end

        member do
          get :cancel
          delete :cancel
          get :valid_discount
          get :thankyou
          get :confirm
          post :apply_discount
          post :set_payment_method
        end
      end


      get "/", to: "register#index"
    end

    get '/', to: redirect('welcome/calendar'), subdomain_failure: true

  end

  # authenticated :user do
  #   root to: "home#welcome", as: "authenticated_root"
  # end

  get 'users' => redirect("/")

  devise_for :users, controllers: {
    confirmations: "confirmations" ,
    registrations: "users/registrations",
    sessions: 'sessions'
  } do
  end

  resources :register do
    collection do
      get :countdown
      get :confirm
    end

    member do
      get :cancel
      delete :cancel
      get :valid_discount
      get :thankyou
      get :confirm
      post :apply_discount
    end
  end


  resources :payments

  resources :lessons


  resources :organizations do
    resources :report, controller: "organizations/organization_reports"
    resources :payment_processors, controller: "organizations/payment_processors"
    resources :dances, controller: "organizations/dances"
    resources :lessons, controller: "organizations/lessons" do
      member do
        post :duplicate
      end
    end

    resources :membership_discounts, controller: "organizations/membership_discounts"
    resources :membership_options, controller: "organizations/membership_options" do
      resources :members, controller: "organizations/membership_options/members"
      resources :membership_renewals, controller: "organizations/membership_options/membership_renewals" do
        collection do
          post :non_members
          get :non_members
        end
      end
    end
    resources :packages
    resources :collaborators, controller: "hosts/collaborators" do
      collection do
        post :invite
        get :accept
      end
    end
  end

  resources :attended_events
  resources :hosted_events do
    member do
      get :a_la_carte_orders
      get :un_destroy
      get :public_registration
      get :pricing_tables
      get :volunteers
      get :packet_printout
      get :revenue
      get :charts
    end

    resources :payment_processors, controller: "hosted_events/payment_processors"
    resources :payments, controller: "hosted_events/payments"
    resources :custom_fields, controller: "hosted_events/custom_fields" do
      member do
        post :undestroy
      end
    end
    resources :reports, controller: "hosted_events/reports"
    resources :checkin, controller: "hosted_events/checkin"
    resources :raffles, controller: "hosted_events/raffles" do
      resources :raffle_tickets, controller: "hosted_events/raffles/raffle_tickets"

      member do
        get :choose_winner
      end
    end
    resources :passes, controller: "hosted_events/passes"
    resources :shirts, controller: "hosted_events/shirts"
    resources :line_items, controller: "hosted_events/line_items"
    resources :housing, controller: "hosted_events/housing"
    resources :collaborators, controller: "hosts/collaborators" do
      collection do
        post :invite
        get :accept
      end
    end
    resources :pricing_tiers, controller: "hosted_events/pricing_tiers"
    resources :cancelled_attendances, controller: "hosted_events/cancelled_attendances"
    resources :attendances, controller: "hosted_events/attendances" do
      collection do
        get :unpaid
        get :print_checkin
      end
      member do
        post :resend_receipt
        put :mark_paid
      end
    end

    resources :levels, controller: "hosted_events/levels"
    resources :dance_only, controller: "hosted_events/dance_only"
    resources :competition_sign_ups, controller: "hosted_events/competition_sign_ups" do
      member do
        get :add_competitions
      end
    end

    get 'individual_items/:id/new', to: "hosted_events/individual_items#new"
    post 'individual_items/:id', to: "hosted_events/individual_items#create"
    resources :individual_items, controller: "hosted_events/individual_items"
    resources :competitions, controller: "hosted_events/competitions" do
      collection do
        get :all
      end
    end
    resources :discounts, controller: "hosted_events/discounts"
    resources :shirts, controller: "hosted_events/shirts"
    resources :packages, controller: "hosted_events/packages"
    resources :sales, controller: "hosted_events/sales"
  end

  namespace :auth do
    get "paypal/callback", to: "paypal#callback"
  end


  get "/back", to: "application#back"
  get "/users/:token/assume_control", to: "application#assume_control"

  # legacy routes
  get "/terms_of_service", to: redirect("welcome/tos")
  get "/privacy", to: redirect("/welcome/privacy")
  get "/calendar", to: redirect("/upcoming-events")
  get "/scenes", to: redirect("/communities")
  # ember routes :-(
  # this can go away once all UI is done in ember
  get "/welcome", to: "marketing#index"
  get "/welcome/*path", to: "marketing#index"
  get "/upcoming-events", to: "marketing#index"
  get "/communities", to: "marketing#index"
  root :to => "marketing#index"
end
