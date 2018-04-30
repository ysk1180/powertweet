Rails.application.routes.draw do
  get 'terms', to: 'terms#index', as: :terms
  get 'privacy', to: 'privacies#index', as: :privacy
  get 'auth/:provider/callback' => 'users#create'#このpathを通して認証が行われる。
  resources :posts, only: [:new, :create, :show]
  root to: "top#index"
end
