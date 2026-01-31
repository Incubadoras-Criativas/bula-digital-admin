Rails.application.routes.draw do

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  root "home#index"

  #carrega o formulário de login
  match 'login', controller: :home, action: :request_login, via: :get
  #ações de autenticação de usuário
  resource :admin_session, only: [:create, :new, :destroy]

  resources :admins
  scope 'adm', controller: :admins do
    patch :adm_page_main
    patch :adm_next_page
    patch :adm_filter
    post :adm_create
    scope ':admin_id' do
      patch :adm_update
      patch :adm_change_password
      patch :adm_update_password
    end
  end

  scope 'users', controller: :users do
    get :users
    patch :user_filter
    patch :user_page_main
    patch :user_next_page
    scope ':user_id' do
      get :user_show
    end
  end

  scope 'bulas', controller: :bulas do
    get :bulas_index
    patch :bula_filter
    patch :bula_page_main
    patch :bula_next_page
    get :bula_new
    post :bula_create
    scope ':bula_id' do
      get :bula_show
      patch :bula_update
      post :bulacc_create
      patch :upload_bula
      scope ':blob_id' do
        patch :processa_pdf
        patch :remove_pdf
      end
      scope ':variation_id' do
        patch :bulacc_update
      end
      scope ':bula_cc_datum_id' do
        patch :update_resumo
        patch :update_curiosidade
      end
      #outras rotas serão inseridas aqui para edição das bulas
    end
  end

  scope "config", controller: :confs do
    get :conf_index
    scope ':app_info_id' do
      patch :update_welcome_message
      patch :update_app_description
      patch :update_use_terms
      patch :conf_new
    end

  end

  #exibição de PDF
  mount PdfjsViewer::Rails::Engine => "/pdfjs", as: 'pdfjs'
  #get 'show_pdf/:pdf_blob_id', controller: :gallery, action: :show_pdf, as: 'show_pdf'
end
