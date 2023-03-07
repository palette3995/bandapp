Rails.application.routes.draw do
  devise_for :users, skip: [:session]
  as :user do
    root to: 'devise/sessions#new', as: :new_user_session
    post 'signin', to: 'devise/sessions#create', as: :user_session
    delete 'signout', to: 'devise/sessions#destroy', as: :destroy_user_session
  end
  resources :users, only: [:index, :show, :edit, :update] do
    collection do
      get 'search'
      get 'match_ages'
      get 'match_levels'
      get 'match_genres'
    end
  end
  resources :bands, except: [:new] do
    collection do
      get 'search'
    end
  end
  get '/bands/user_bands/:id', to: 'bands#user_bands', as: 'user_bands'
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
    end
    member do
      get 'new_user'
      get 'new_band'
      get 'approve_new'
      get 'approve_offer'
      get 'approve_join'
      get 'approve_marge'
      get 'refuse'
    end
  end
end
