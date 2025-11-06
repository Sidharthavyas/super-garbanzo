Rails.application.routes.draw do
  # Reveal health status on /up
  get "up" => "rails/health#show", as: :rails_health_check

  # Root route
  root 'autodialer#index'
  
  # Autodialer routes
  post 'autodialer/create', to: 'autodialer#create'
  post 'autodialer/bulk_upload', to: 'autodialer#bulk_upload'
  post 'autodialer/ai_command', to: 'autodialer#ai_command'
end