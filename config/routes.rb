Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :videos
    end
  end

  root 'videos#index'
end
