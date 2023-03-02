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
    end
  end
  resources :bands, except: [:new]
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
