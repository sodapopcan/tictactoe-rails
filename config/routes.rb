Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "games#index"
  resources :games
  put "games/:id/join", to: "games#join", as: :join_game
  put "games/:id/move/:cell_index", to: "games#move", as: :play_game
end
