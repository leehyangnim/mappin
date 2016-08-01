Rails.application.routes.draw do

  root "posts#index"

  get "/auth/facebook", as: :sign_in_with_facebook
  get "/auth/facebook/callback" => "callbacks#facebook"

  get "/users/edit_password" => "users#edit_password", as: :edit_password
  patch "users"             => "users#update_password", as: :update_password

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
