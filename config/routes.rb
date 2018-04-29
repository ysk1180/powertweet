Rails.application.routes.draw do
  get 'top/index'
  get 'auth/:provider/callback' => 'users#create'#このpathを通して認証が行われる。
  resources :posts
  root to: "top#index"
end
