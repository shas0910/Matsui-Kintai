Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :year_months, only: [:new, :create]

  scope :year_month do
    get 'days', to: 'year_months/new#new_days'
    post 'days', to: 'year_months/new#new_days'
  end

end