# frozen_string_literal: true
Rails.application.routes.draw do
  # allows access to the API via http://herokuapp.com/api/any_endpoint
  # namespace :api, defaults: { format: :json }, path: '/api' do
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do # versioning
      resources :reps, only: [:index]
    end
    namespace :beta do # beta version
      resources :reps,   only: [:index]
      resources :issues, only: [:index, :new, :create, :update]
    end
  end

  resources :reps, only: [:index]
  # resources :issues, only: [:index, :new, :create, :update]
  
  get '/v_cards/:id',  to: 'v_cards#show'

  # OSDI STUFF!
  get '/osdi/people' => 'reps2#index'
  get '/osdi/people/:id' => 'reps2#show'
  get '/osdi' => 'reps2#aep'
end
