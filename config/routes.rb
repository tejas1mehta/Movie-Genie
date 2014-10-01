MovieGenie::Application.routes.draw do
  root to: 'static_pages#root'

  get "/api/casts/search" => "api/casts#search"
  get "/api/studios/search" => "api/studios#search"
  get "/api/users/get_info" => "api/users#get_info"

  namespace :api, defaults: { format: :json } do
    resource :session, only: [:create, :destroy]
    resources :users, only: [:create, :destroy, :update]

    resources :genres, only: [:index,:show]
    resources :movies, only: [:index,:show]
    resources :studios, only: [:show]
    resources :casts, only: [:show]
    resources :user_list_joins, only: [:create, :destroy]
    resources :user_not_interested_joins, only: [:create, :destroy]    
    resources :user_rating_joins, only: [:create, :update]
  end
  
  get "/auth/:provider/callback" => "api/sessions#createauth"
  # post "/auth/:provider/callback" => "api/sessions#createauth"

end
