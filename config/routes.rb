Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resource :search, only: [:create]
    end
    namespace :v2 do
      resource :search, only: [:create]
    end
  end
end
