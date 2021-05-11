Rails.application.routes.draw do
  devise_for :users
  root "pages#index"
  get 'pages/show', as: '/show'
  get 'pages/about', as: '/about'

  # Favorites Routes
  get 'favorites/show', to: "favorites#show"
  post 'favorites/add', to: "favorites#add"
  put 'favorites/delete', to: "favorites#delete"
  delete 'favorites/erase', to: "favorites#erase"
end
