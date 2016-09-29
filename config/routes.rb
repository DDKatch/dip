Rails.application.routes.draw do
  get 'image_processors/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :image_processors

  root 'image_processors#index'
end
