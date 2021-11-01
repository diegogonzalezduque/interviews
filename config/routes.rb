Rails.application.routes.draw do
  devise_for :users
  resources :contacts
  resources :users
  resources :csv_processing do
    collection do
      post :column_matcher
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
