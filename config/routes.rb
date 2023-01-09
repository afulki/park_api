# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :cages
      resources :dinosaurs

      # Additional routes
      post '/cages/filter_by_state', to: 'cages#filter_by_state'

      post '/dinosaurs/filter_by_species', to: 'dinosaurs#filter_by_species'
      post '/dinosaurs/filter_by_cage', to: 'dinosaurs#filter_by_cage'
      put '/dinosaurs/:id/move_to_cage', to: 'dinosaurs#move_to_cage'
    end
  end
end
