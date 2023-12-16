Rails.application.routes.draw do
  resources :photos, only: [:index, :create, :show, :destroy, :update] do
    get 'likes', to: 'photo_likes#index'
    post 'like', to: 'photo_likes#create'
    delete 'unlike', to: 'photo_likes#destroy'
    resources :comments, only: [:index, :create, :show, :destroy] do
      resources :replies, only: [:index, :create, :show, :destroy]
    end
  end
  mount_devise_token_auth_for 'User', at: 'auth'
end
