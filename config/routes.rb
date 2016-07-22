Rails.application.routes.draw do

  root "posts#index"

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
    resources :comments, only: [:create, :destroy]
  end

end
