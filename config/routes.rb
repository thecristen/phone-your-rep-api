# frozen_string_literal: true
Rails.application.routes.draw do
  # allows access to the API via http://herokuapp.com/api/any_endpoint
  # namespace :api, defaults: { format: :json }, path: '/api' do
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do # versioning
      resources :reps
    end
  end
  
  resources :reps #, defaults: { format: 'json' }
  resources :issues, only: [:index, :new, :create, :update]

  get '/v_cards/:id',  to: 'v_cards#show'
end
