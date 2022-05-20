Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  root to: 'timecards#new'

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  resources :users, only: [:index, :edit, :update, :destroy]
  
  resources :year_months, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    member do
      get 'to_show'
      get 'total'
    end
  end

  get 'user/:user_id/year_month/:id', to: 'year_months#manage'
  get 'user/:user_id/year_month/:id/to_manage', to: 'year_months#to_manage'

  get 'requests', to: 'requests#index'

  resources :day do
    resources :pending_timecards, only: [:new, :create]
    resources :pending_schedules, only: [:new, :create]
  end

  get 'user/:user_id/day/:day_id/edit_timecard', to: 'timecards#edit'
  get 'user/:user_id/day/:day_id/edit_schedule', to: 'schedules#edit'

  get 'user/:user_id/day/:day_id/update_timecard', to: 'timecards#update'
  get 'user/:user_id/day/:day_id/update_schedule', to: 'schedules#update'

  resources :pending_timecards, only: [:update, :destroy] do
    member do
      patch 'permission'
    end
  end

  resources :pending_schedules, only: [:update, :destroy] do
    member do
      patch 'permission'
    end
  end

  get 'permissions', to: 'permissions#index'

  resources :timecards, only: [:index, :new, :create] do
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

  get 'setting', to: 'settings#setting'

  resources :commutes, only: [:new, :create]

  get 'commute/:user_id', to: 'commutes#edit'
  get 'commute/:user_id/update', to: 'commutes#update'

  resources :travel_costs, only: [:destroy] do
    collection do
      post 'create_car'
      post 'create_train'
      post 'create_pass'
      post 'create_walk'
      post 'create_trip'
      post 'create_remote'
      post 'create_other'
    end
  end

  get 'travel_cost/index/:user_id/:year_month_id', to: 'travel_costs#index'
  get 'travel_cost/index/:user_id/:year_month_id/to_index', to: 'travel_costs#to_index'

  get 'travel_cost/edit/:user_id/:day_id', to: 'travel_costs#edit'

  get 'travel_cost/update_car/:user_id/:day_id', to: 'travel_costs#update_car'
  get 'travel_cost/update_train/:user_id/:day_id', to: 'travel_costs#update_train'
  get 'travel_cost/update_pass/:user_id/:day_id', to: 'travel_costs#update_pass'
  get 'travel_cost/update_walk/:user_id/:day_id', to: 'travel_costs#update_walk'
  get 'travel_cost/update_trip/:user_id/:day_id', to: 'travel_costs#update_trip'
  get 'travel_cost/update_remote/:user_id/:day_id', to: 'travel_costs#update_remote'
  get 'travel_cost/update_other/:user_id/:day_id', to: 'travel_costs#update_other'
  
end