Rails.application.routes.draw do
  get 'auth/:provider/callback' => 'users#create'#このpathを通して認証が行われる。
  resources :posts
  root to: "posts#index"
end
