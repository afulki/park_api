# frozen_string_literal: true

require 'rails_helper'

module Api
  module V1
    RSpec.describe DinosaursController, type: :controller do
      describe '#index' do
        it 'assigns @dinosaurs' do
          dino = create(:dinosaur, :carnivore, cage: 1) # For this test, don't care about the cage

          get :index
          expect(assigns(:dinosaurs)).to eq([dino])
        end

        it 'renders the index template' do
          get :index
          assert_response 200
        end

        it 'returns a json response matching the created dinosaur' do
          dino = create(:dinosaur, :carnivore, cage: 1) # For this test, don't care about the cage

          get :index
          parsed_body = JSON.parse(response.body)

          expect(parsed_body[0]['name']).to eq(dino.name)
          expect(parsed_body[0]['species']).to eq(dino.species)
          expect(parsed_body[0]['carnivore']).to eq(dino.carnivore)
        end
      end

      describe '#show' do
        it 'retrieves a single dinosaur by id' do
          dino = create(:dinosaur, :herbivore, cage: 1) # For this test, don't care about the cage

          get :show, params: { id: dino.id }, format: :json
          assert_response 200
        end
      end

      describe '#create' do
        it 'creates a new valid dinosaur' do
          create(:cage, :active, id: 1)

          post :create, params: {
            name: Faker::Name.name,
            species: 'Tyrannosaurus',
            cage: 1
          }, format: :json # For this test, don't care about the cage

          assert_response 201
        end

        it 'responds with error if invalid data' do
          post :create, params: { name: Faker::Name.name }, format: :json

          assert_response 422
        end
      end

      describe '#filter_by_cage' do
        it 'returns only the dinosaurs with the given cage' do
          create(:cage, :active, id: 1)
          create(:cage, :active, id: 2)

          create_list(:dinosaur, 5, :carnivore, species: 'Tyrannosaurus', cage: 1)
          herbi = create(:dinosaur, :herbivore, cage: 2)

          post 'filter_by_cage', params: { cage: herbi.cage }

          assert_response 200

          parsed_body = JSON.parse(response.body)
          expect(parsed_body[0]['id']).to eq(herbi.id)
        end
      end

      describe '#filter_by_species' do
        it 'returns only the dinosaurs with the given species' do
          create(:cage, :active, id: 1)
          create(:cage, :active, id: 2)

          create_list(:dinosaur, 5, :carnivore, species: 'Tyrannosaurus', cage: 1)
          herbi = create(:dinosaur, :herbivore, cage: 2)

          post 'filter_by_species', params: { species: herbi.species }

          assert_response 200

          parsed_body = JSON.parse(response.body)
          expect(parsed_body[0]['species']).to eq(herbi.species)
        end
      end

      describe 'moving dino between cages' do
        it 'returns an error if the destination cage is the same as the source' do
          cage = create(:cage, :active, id: 1)
          dino = create(:dinosaur, :herbivore, cage: 1)

          put 'move_to_cage', params: { id: dino.id, cage: 1 }

          assert_response 422
          parsed_body = JSON.parse(response.body)

          expect(parsed_body['message']).to eq('Error - the dinosaur is already in the given cage')
          cage.reload
          expect(cage.dinosaur_count).to eq(0)
        end

        it 'updates the cage dinosaur count when moved' do
          src_cage = Cage.create(id: 1, capacity: 10, status: 'ACTIVE')
          dest_cage = Cage.create(id: 2, capacity: 10, status: 'ACTIVE')

          # Using the controller to create and initialize everything correctly (i.e. add the dino to the cage)
          post :create, params: { name: 'Rudolph', species: 'Brachiosaurus', cage: src_cage.id }
          expect(response.status).to eq(201)

          dino_id = JSON.parse(response.body)['id']

          expect(src_cage.reload.dinosaur_count).to eq(1)

          put 'move_to_cage', params: { id: dino_id, cage: dest_cage.id }

          expect(response.status).to eq(200)
          expect(src_cage.reload.dinosaur_count).to eq(0)
          expect(dest_cage.reload.dinosaur_count).to eq(1)
        end
      end
    end
  end
end
