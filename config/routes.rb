Rails.application.routes.draw do
  resources :officers
  resources :incidents
  root "root#index"
end
