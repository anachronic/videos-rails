Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :videos
    end
  end

  devise_for :admins, defaults: { format: :json }

  root 'videos#index'
end
