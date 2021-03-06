Rails.application.routes.draw do
  root to: "home#index"
  devise_for :users

  resources :tools
  resources :projects, only: %i[new create show]
  resources :posts
  resources :comments

  post "projects/update_by_field", to: "projects#update_by_field"
  patch "projects/update_tools", to: "projects#update_tools", as: "update_tools"

  post "posts/likes", to: "posts#like"

  get "profile/:id", to: "users#show", as: "profile"

  scope :users do
    post "follow", to: "users#follow", as: "follow"
    post "unfollow", to: "users#unfollow", as: "unfollow"
    post "toggle_follow", to: "users#toggle_follow", as: "toggle_follow"
    post "subscribe_to_notifications", to: "users#subscribe_to_notifications"

    scope :onboarding do
      post :finish, to: "users#finish_onboarding"
    end
  end
end
