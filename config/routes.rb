Rails.application.routes.draw do
  resources :articles do
    member do
      get 'generate_qr_code'
      get 'search'
    end
  end
  post '/generate_all_qrs', to: 'articles#generate_all_qrs', as: 'generate_all_qrs'


  devise_for :users

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'articles#index'
end
