Rails.application.routes.draw do

  get 'notifications/link_through'

  root "sessions#new"

  get "/auth/facebook", as: :sign_in_with_facebook
  get "/auth/facebook/callback" => "callbacks#facebook"

  get "/auth/twitter", as: :sign_in_with_twitter
  get "/auth/twitter/callback" => "callbacks#twitter"

  get "/users/edit_password" => "users#edit_password", as: :edit_password
  patch "users"             => "users#update_password", as: :update_password

  get 'notifications/:id/link_through', to: 'notifications#link_through',
                                       as: :link_through

  resources :users, only: [:new, :create] do
    get :edit, on: :collection
    patch :update, on: :collection
  end

  resources :sessions, only: [:new, :create] do
    delete :destroy, on: :collection
  end

  resources :posts do
    get :cluster, on: :collection
    resources :post_likes, only: [:create,:destroy]
    resources :comments, only: [:create, :destroy]
  end

end
