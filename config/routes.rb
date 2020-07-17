Rails.application.routes.draw do
  concern :with_datatable do
    post 'datatable', on: :collection
  end

  resources :field_contacts, concerns: [:with_datatable]
  resources :incidents, concerns: [:with_datatable]
  resources :officers, concerns: [:with_datatable]
  resources :complaints, concerns: [:with_datatable]
  resources :cases, concerns: [:with_datatable]
  resources :swats, concerns: [:with_datatable]
  resources :details, concerns: [:with_datatable]
  resources :citations, concerns: [:with_datatable]
  resources :articles, concerns: [:with_datatable]

  root "root#index"
end
