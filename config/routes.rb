Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  resources :users, only: [:index, :edit, :update, :destroy]
  
  resources :year_months, only: [:index, :new, :create, :edit, :update, :destroy]

end
