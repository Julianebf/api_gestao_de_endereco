Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  resources :addresses do
    member do
      patch :set_primary
    end
  end

  root "addresses#index"
end
