Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :pets do
    resources :clinical_histories, except: [:show, :destroy]
  end
  resources :pets do
    resources :vaccinations, except: [:show, :destroy]
  end
  resources :pets do
    resources :studies, except: [:show, :destroy]
  end
  resources :pets do
    resources :veterinaries, only: [:show, :index]
  end

  resources :pets do
    resources :appointments, only: [:index]
  end

  resources :appointments, except: [:show, :index]
  resources :reviews, only: [:new, :create]

  get 'my_appointments', to: 'appointments#my_appointments', as: 'my_appointments'
  get 'my_patients', to: 'appointments#my_patients', as: 'my_patients'
  get 'vet_profile', to: 'veterinaries#vet_profile', as: 'vet_profile'


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :chatrooms, only: :show do
    resources :messages, only: :create
  end
end
