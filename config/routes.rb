Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # TODO-- determine which RESTful routes are needed later
  resources :drivers
  resources :trips
  resources :passengers
end
