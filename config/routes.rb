Rails.application.routes.draw do
  resources :officers
  root "root#index"
end
