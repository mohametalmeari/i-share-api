Rails.application.routes.draw do
  resources :photos, only: [:index, :create, :show, :destroy, :update]
  mount_devise_token_auth_for 'User', at: 'auth'
end
