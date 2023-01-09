# frozen_string_literal: true

require 'rails_helper'

module Api
  module V1
    RSpec.describe CagesController do
      describe '#index' do
        it 'returns a list of cages' do
          cage = create(:cage, :active)
          create(:cage, :down)

          get :index

          parsed_body = JSON.parse(response.body)

          expect(parsed_body.length).to eq(2)
          expect(parsed_body[0]['capacity']).to eq(cage.capacity)
          expect(parsed_body[0]['dinosaur_count']).to eq(cage.dinosaur_count)
          expect(parsed_body[0]['status']).to eq('ACTIVE')
          expect(parsed_body[1]['status']).to eq('DOWN')
        end
      end

      describe '#filter_by_state' do
        it 'returns a list of cages filtered by active' do
          create_list(:cage, 3, :active)
          create(:cage, :down)

          post 'filter_by_state', params: { status: 'ACTIVE' }

          parsed_body = JSON.parse(response.body)

          assert_response 200
          expect(parsed_body.length).to eq(3)
          expect(parsed_body[0]['status']).to eq('ACTIVE')
        end

        it 'returns a list of cages filtered by down' do
          create_list(:cage, 3, :active)
          create(:cage, :down)

          post 'filter_by_state', params: { status: 'DOWN' }

          parsed_body = JSON.parse(response.body)

          assert_response 200
          expect(parsed_body.length).to eq(1)
          expect(parsed_body[0]['status']).to eq('DOWN')
        end

        it 'return an error if a status other than down or active is passed to filter' do
          post 'filter_by_state', params: { status: 'BAD_FILTER' }

          parsed_body = JSON.parse(response.body)

          assert_response 422
          expect(parsed_body['message']).to eq('Can only filter on status equal to "DOWN" or "ACTIVE"')
        end
      end
    end
  end
end
