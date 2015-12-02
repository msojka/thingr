Rails.application.routes.draw do
  root to: 'home#index'
  
  resources :things do
    member do
      post :create_comment
      get :next_comments
    end
  end
  
  get "sessions/sign_up_form"
  post "sessions/sign_up"
  get "sessions/sign_out"
  get "sessions/sign_in_form"
  post "sessions/sign_in"
  get  "sessions/wake_up_form/:id", controller: :sessions, action: :wake_up_form
  post "sessions/wake_up/:id", controller: :sessions, action: :wake_up, as: :sessions_wake_up
  
end
