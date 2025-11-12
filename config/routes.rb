Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "homes#top"
  get "home/about"=>"homes#about"

  devise_for :users
  resources :books, only: [:index,:show,:edit,:create,:destroy,:update]do
    resource :favorite, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end

  resources :users, only: [:show, :index, :edit, :update] do
  resources :relationships, only: [:create, :destroy]

  get "followings", on: :member, as: :followings
  get "followers", on: :member, as: :followers
  end

  #get "followings", on: :collection, as: :followings
  #get "followers",  on: :collection, as: :followers
  #end

  #resources :books do
  #resource :favorite, only: [:create, :destroy]
  #end
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

end