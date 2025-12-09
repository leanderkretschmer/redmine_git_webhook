Rails.application.routes.draw do
  resources :issues do
    resource :github_webhook, only: [:show, :create, :update, :destroy], path: 'github'
  end

  post 'github_webhooks/:id/receive', to: 'github_webhook_receiver#receive', as: 'github_webhook_receive'
end

