Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/', to: 'recipes#index'
      post '/ingredients/', to: 'ingredients#create'
      delete '/ingredients/', to: 'ingredients#destroy'
      post '/users/', to: 'users#create'
      post '/login/', to: 'auth#create'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
