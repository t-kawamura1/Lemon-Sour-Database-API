Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :lemon_sours, only: [:show, :index]
    end
  end
end
