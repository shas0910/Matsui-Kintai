Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  resources :users, only: [:index, :edit, :update, :destroy]
  
  resources :year_months, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    member do
      get 'to_show'
    end
  end

  get 'user/:user_id/year_month/:id', to: 'year_months#manage'
  get 'user/:user_id/year_month/:id/to_manage', to: 'year_months#to_manage'

  resources :day do
    resources :pending_timecards, only: [:new, :create]
    resources :pending_schedules, only: [:new, :create]
  end

  resources :pending_timecards, only: :update do
    member do
      patch 'permission'
    end
  end

  resources :pending_schedules, only: :update do
    member do
      patch 'permission'
    end
  end

  get 'permissions', to: 'permissions#index'

  resources :timecards, only: [:index, :new, :create, :update] do
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