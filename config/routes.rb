Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  resources :users, only: [:index, :edit, :update, :destroy]
  
  resources :year_months, only: [:index, :new, :create, :edit, :update, :destroy]

  resources :day do
    resources :pending_timecards, only: [:new, :create]
  end

  resources :timecards, only: [:new, :create, :update] do
    collection do
      post 'create_start'
      post 'create_finish'
      post 'create_break_start'
      post 'create_break_finish'
    end
    member do
      patch 'update_start'
      patch 'update_finish'
      patch 'update_break_start'
      patch 'update_break_finish'
    end
  end

end