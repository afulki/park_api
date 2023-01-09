# frozen_string_literal: true

module Api
  module V1
    # Impements the restul api for dinosaurs
    class DinosaursController < ApplicationController
      include Response
      include ExceptionHandler

      before_action :set_dinosaur, only: %i[show update destroy]

      # GET /dinosaurs
      def index
        @dinosaurs = Dinosaur.all
        json_response(@dinosaurs)
      end

      # GET /dinosaurs/:id
      def show
        json_response(@dino)
      end

      # POST /dinosaurs
      def create
        @dino = Dinosaur.create!(dinosaur_params)

        increment_cage_dinosaur_count(params[:cage])

        json_response(@dino, :created)
      end

      # PUT /dinosaurs/:id
      def update
        @dino.update(update_params)
        json_response(@dino)
      end

      # DELETE /dinosaurs/:id
      def destroy
        @dino.destroy
        head :no_content
      end

      # Filters

      # POST /dinosaurs/filter_by_cage
      def filter_by_cage
        @dinos = Dinosaur.where({ cage: params[:cage] })
        json_response(@dinos)
      end

      # POST /dinosaurs/filter_by_species
      def filter_by_species
        @dinos = Dinosaur.where({ species: params[:species] })
        json_response(@dinos)
      end

      # Management

      # PUT /dinosaurs/:id/move_to_cage
      def move_to_cage
        @dino = Dinosaur.find(params[:id])

        set_cage!
        already_in_cage?(@dino.cage, params[:cage])
        cage_down?

        source_dino_cage = @dino.cage
        # As the valdator checks the cage being assigned, we don't need to check here
        @dino.update(valid_cage_params)
        # likewise for the max
        increment_cage_dinosaur_count(params[:cage])
        decrement_cage_dinosaur_count(source_dino_cage)

        json_response(@dino.reload)
      end

      private

      def cage_down?
        return unless @cage.down?

        raise ArgumentError, 'Error - cannot add dinosaur to unpowered cage'
      end

      def already_in_cage?(current_cage, destination_cage)
        # Make sure they are both strings, as params comes in as a string
        return unless current_cage.to_s == destination_cage.to_s

        raise ArgumentError, 'Error - the dinosaur is already in the given cage'
      end

      def dinosaur_params
        params.permit(:name, :species, :cage)
      end

      def update_params
        params.permit(:name, :species)
      end

      def valid_cage_params
        params.permit(:cage)
      end

      def set_dinosaur
        @dino = Dinosaur.find(params[:id])
      end

      def set_cage!
        @cage = Cage.find(params[:cage])
      end

      # TODO: Perhaps move these to the Cage class
      def increment_cage_dinosaur_count(cage_id)
        cage = Cage.find(cage_id)
        cage.update(dinosaur_count: cage.dinosaur_count + 1)
      end

      def decrement_cage_dinosaur_count(cage_id)
        cage = Cage.find(cage_id)
        cage.update(dinosaur_count: cage.dinosaur_count - 1)
      end
    end
  end
end
