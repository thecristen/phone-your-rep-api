# frozen_string_literal: true
Rails.application.routes.draw do
  # allows access to the API via http://herokuapp.com/api/any_endpoint
  # namespace :api, defaults: { format: :json }, path: '/api' do
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do # version 1
      resources :reps, only: [:index]
      resources :issues, only: [:index, :new, :create, :update]
    end

    namespace :beta do # beta version
      resources :reps,   only: [:index]
      resources :issues, only: [:index, :new, :create, :update]
    end
  end

  get '/reps', to: 'reps#index'
  get '/reps/:bioguide_id', to: 'reps#show'
  # resources :reps, only: [:index, :show]
  resources :issues, only: [:index, :new, :create, :update]

  get '/v_cards/:id', to: 'v_cards#show'

  # OSDI STUFF!
  get '/osdi/people' => 'osdi_reps#index'
  get '/osdi/people/:id' => 'osdi_reps#show'
  get '/osdi' => 'osdi_reps#aep'
end
