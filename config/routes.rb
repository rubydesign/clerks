Rails.application.routes.draw do

  root to: 'high_voltage/pages#show' , id: 'index'

  get "/blog" , to: "blog#index" , as: :blog_index
  get "/blog/*title" , to: "blog#post" , as: :blog_post

  get "sign_out" => "sessions#sign_out"
  get "sign_in"  => "sessions#sign_in"
  post "create_session"  => "sessions#create"
  match "sign_up" => "sessions#sign_up" , :via => [:get ,:post]

  resources :purchases do
    collection do
      get "search" => "purchases#index"
    end
    member do
      get :invoice, to: 'purchase_invoices#show'
      get :order
      get :receive
      get :inventory
    end
  end

  resources :baskets do
    collection do
      get "search" => "baskets#index"
    end
    member do
      get :discount
      post :ean
      get :order
      get :purchase
      get :zero
    end
  end

  resources :houses , :except => [:show , :destroy] do
    collection do
      get :products
    end
  end

  resources :orders , :except => [:edit] do
    collection do
      get "search" => "orders#index"
    end
    member do
      get "mail/:act" , :action => :mail , :as => :mail
      get :pay
      get :shipment
      get :ship
      get :deduct_only
      get :cancel
      patch :shipment
      get :invoice
      get :receipt
      get :slip
      get :reminder
      get :rakennus
      get :ecoframe
      get "finvoice_:num" , action: :finvoice , as: :finvoice
    end
  end

  resources :items do
    collection do
      get "search" => "items#index"
    end
    member do
    end
  end

  resources :categories do
    collection do
      get "search" => "categories#index"
    end
    member do
    end
  end

  resources :products do
    collection do
      get "search" => "products#index"
      get :names
    end
    member do
      get :delete
      get :barcode  #print the barcode and price on a 50x25 mm area
    end
  end

  resources :clerks do
    collection do
      get "search" => "clerks#index"
    end
    member do
    end
  end

  resources :addresses do
    collection do
      get "search" => "addresses#index"
    end
  end

  resources :suppliers do
    collection do
      get "search" => "suppliers#index"
    end
    member do
    end
  end

  get "manage/all" => "manage#all"
  get '/manage/reports' => 'manage#reports'

  get "api/purchase" => "api#purchase" , format: :json

  get "/3d/*id" => 'kolme_d#show' , as: :kolme_d
end

Rails.application.config.after_initialize do |application|
  application.routes.append do
    match '*path', via: :all, to: 'high_voltage/pages#show' , id: "404"#if Rails.production?
  end
end
