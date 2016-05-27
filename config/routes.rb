Rails.application.routes.draw do

  root 'welcome#index'

  namespace :api, defaults: { format: :json } do
    resources :news, only: [:index, :show] do
      collection do
        get 'top_news', action: 'top_news', as: :top_news
      end
    end
  end
end
