Rails.application.routes.draw do
  get 'homeworks/index'

  get 'image_processors/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # resources :image_processors
  resources :homeworks

  root 'image_processors#index'
end
