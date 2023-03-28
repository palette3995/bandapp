Rails.application.routes.draw do
  devise_for :users, skip: [:session], :controllers => {
    :registrations => 'users/registrations',
    :passwords => 'users/passwords'
   }
  as :user do
    root to: 'devise/sessions#new', as: :new_user_session
    post 'signin', to: 'devise/sessions#create', as: :user_session
    delete 'signout', to: 'devise/sessions#destroy', as: :destroy_user_session
    post 'guest_signin', to: "users/sessions#guest_sign_in", as: :guest_user_session
  end
  resources :users, only: [:index, :show, :edit, :update] do
    collection do
      get 'search'
      get 'match_ages'
      get 'match_levels'
      get 'match_genres'
    end
  end
  resources :bands, except: [:new, :create] do
    collection do
      get 'search'
      get 'match_ages'
      get 'match_genres'
      get 'user_bands'
    end
  end
  resources :band_members, except: [:new]
  resources :recruit_members, except: [:new]
  get '/recruit_members/new/:id', to: 'recruit_members#new', as: 'new_recruit_member'
  resources :scouts, except: [:new] do
    collection do
      get 'received_offer'
      get 'received_join'
      get 'received_marge'
      get 'send_new'
      get 'send_offer'
      get 'send_join'
      get 'send_marge'
      post 'create_band'
    end
    member do
      get 'new_user'
      get 'new_band'
      delete 'approve_new'
      delete 'approve_offer'
      delete 'approve_join'
      delete 'approve_marge'
      delete 'refuse'
    end
  end

  resources :favorites, only: [:index, :destroy] do
    collection do
      get 'send_band'
      get 'received_user'
      get 'received_band'
    end
    member do
      post 'create_user'
      post 'create_band'
      delete 'destroy_band'
    end
  end

  resources :chats, only: [:show, :create]
  resources :notifications, only: [:index] do
    collection do
      get 'unreads'
      patch 'read_all'
    end
    member do
      patch 'read'
    end
  end
end
