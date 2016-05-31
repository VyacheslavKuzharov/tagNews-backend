Rails.application.routes.draw do

  root 'welcome#index'

  devise_for :users, controllers: { registrations: 'api/users/registrations',
                                    sessions: 'api/users/sessions',
                                    passwords: 'api/users/passwords'
  }

  namespace :api, defaults: { format: :json } do
    resources :news, only: [:index, :show] do
      collection do
        get 'top_news', action: 'top_news', as: :top_news
      end
      member do
        get '/comments', action: 'comments', as: :comments
      end
    end

    resources :comments, only: [:create]
  end
end
