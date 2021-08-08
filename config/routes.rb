Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'api/v1/auth/registrations',
      }
      resources :lemon_sours, only: %i(show index) do
        collection do
          get 'search_by'
        end
      end
      resources :drinking_records, only: %i(show create) do
        collection do
          get 'amounts_by_month'
          delete 'delete'
        end
      end
    end
  end
end
