Rails.application.routes.draw do
  # allows access to the API via http://herokuapp.com/api/any_endpoint
  # namespace :api, defaults: { format: :json }, path: '/api' do

  resources :reps
  resources :zipcodes
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
