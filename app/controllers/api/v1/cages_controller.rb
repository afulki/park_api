# frozen_string_literal: true

module Api
  module V1
    # Impements the restul api
    class CagesController < ApplicationController
      include Response
      include ExceptionHandler

      before_action :set_cage, only: %i[show update destroy]

      def index
        @cages = Cage.all
        json_response(@cages)
      end

      def show
        json_response(@cage)
      end

      def create
        @cage = Cage.create!(cage_params)
        json_response(@cage, :created)
      end

      def update
        if params.key?(:status) &&
           params[:status] == 'DOWN' &&
           @cage.dinosaur_count.postitve?
          raise StandardError 'Cage contains dinosaur, cannot shut down!'
        end

        @cage.update(update_params)
        json_response(@cage)
      end

      def destroy
        @cage.destroy
        head :no_content
      end

      # Filters
      #

      def filter_by_state
        case params[:status]
        when 'DOWN'
          @cages = Cage.powered_off
        when 'ACTIVE'
          @cages = Cage.powered_on
        else
          raise ArgumentError, 'Can only filter on status equal to "DOWN" or "ACTIVE"'
        end

        json_response(@cages)
      end

      private

      def cage_params
        params.permit(:capacity, :status, :dinosaur_count)
      end

      def set_cage
        @cage = Cage.find(params[:id])
      end
    end
  end
end
