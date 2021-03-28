Rails.application.routes.draw do
  concern :with_datatable do
    post 'datatable', on: :collection
  end

  resources :field_contacts, concerns: [:with_datatable]
  resources :incidents, concerns: [:with_datatable]
  resources :officers, concerns: [:with_datatable] do
    get 'select2', on: :collection
    post 'confirm_all_articles', on: :member
    get 'field_contacts', on: :member
  end
  resources :complaints, concerns: [:with_datatable]
  resources :cases, concerns: [:with_datatable]
  resources :swats, concerns: [:with_datatable]
  resources :details, concerns: [:with_datatable]
  resources :citations, concerns: [:with_datatable]
  resources :articles, concerns: [:with_datatable]
  resources :articles_officers
  resources :organizations
  resources :appeals do
    get 'csv', on: :collection
  end

  get ':id', to: 'sitemaps#show', constraints: { id: /sitemap[a-z0-9.]+/ }
  get 'exports', to: 'exports#index'
  get "/pages/*id" => 'pages#show', as: :page, format: false
  get "/help/*id" => 'help#show', as: :help, format: false
  get "/data_sources" => 'data_sources#index', as: :data_sources, format: false
  get "/data_sources/*id" => 'data_sources#show', as: :data_source, format: false

  root "root#index"
end
