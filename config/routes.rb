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
  get '/v_cards/:id',  to: 'v_cards#show'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
