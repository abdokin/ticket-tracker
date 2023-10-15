Rails.application.routes.draw do
  resources :articles do
    member do
      get 'generate_qr_code_lg'
      get 'generate_qr_code_sm'

    end
  end
  devise_for :users

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'articles#index'
end
