Rails.application.routes.draw do
  concern :with_datatable do
    post 'datatable', on: :collection
  end

  resources :officers, concerns: [:with_datatable]
  resources :incidents, concerns: [:with_datatable]
  root "root#index"
end
