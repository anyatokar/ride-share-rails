Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'homepages#index'
  # TODO-- determine which RESTful routes are needed later
  resources :drivers
  resources :trips, except: [:new, :index, :create]
  resources :passengers do
    resources :trips, only: [:create]
  end
  resources :homepages, only: [:index]

end
