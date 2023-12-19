Rails.application.routes.draw do
  get 'about', to: 'about#index'
  resources :photos, only: [:index, :create, :show, :destroy, :update] do
    get 'likes', to: 'photo_likes#index'
    post 'like', to: 'photo_likes#create'
    delete 'unlike', to: 'photo_likes#destroy'
    resources :comments, only: [:index, :create, :show, :destroy] do
      get 'likes', to: 'comment_likes#index'
      post 'like', to: 'comment_likes#create'
      delete 'unlike', to: 'comment_likes#destroy'
      resources :replies, only: [:index, :create, :show, :destroy] do
        get 'likes', to: 'reply_likes#index'
        post 'like', to: 'reply_likes#create'
        delete 'unlike', to: 'reply_likes#destroy'
      end
    end
  end
  mount_devise_token_auth_for 'User', at: 'auth'
end
