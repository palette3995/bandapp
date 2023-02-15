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
    end
  end
  resources :bands

end
