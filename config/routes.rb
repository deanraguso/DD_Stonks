Rails.application.routes.draw do
  root "pages#index"
  get 'pages/show', as: '/show'
  get 'pages/about', as: '/about'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
