Rails.application.routes.draw do
  mount API::Base, at: '/api'
  namespace :admin do 
    get '/', to: 'users#index', as: :users
    resources :users, except: %i[new create] do
      post :disable_2fa, on: :member
      resources :labels, except: %i[index show]
    end
    resources :profiles, only: %i[edit update] do
      put :document_label, on: :member
    end
  end
end
