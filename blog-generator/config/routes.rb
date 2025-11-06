Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Root route
  root 'articles#index'
  
  # Generator routes (MUST come BEFORE resources)
  get 'articles/new', to: 'articles#new', as: 'new_articles'
  post 'articles/generate', to: 'articles#generate', as: 'generate_articles'
  
  # Articles routes (MUST come AFTER specific routes)
  resources :articles, only: [:index, :show]
end