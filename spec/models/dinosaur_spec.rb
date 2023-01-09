# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Dinosaur, type: :model do
  describe 'Simple Validation Tests' do
    it 'is not valid without a name' do
      dino = Dinosaur.new(name: nil, species: 'Tyrannosaurus', cage: 1)
      expect(dino).to_not be_valid
    end

    it 'is not valid without a species' do
      dino = Dinosaur.new(name: 'Dino', species: nil, cage: 1)
      expect(dino).to_not be_valid
    end

    it 'is valid when species is Stegosaurus' do
      dino = Dinosaur.new(name: 'Brian', species: 'Stegosaurus', cage: 1)
      expect(dino).to be_valid
    end

    it 'is valid when Tyrannosaurus' do
      dino = Dinosaur.new(name: 'Frank', species: 'Tyrannosaurus', cage: 1)
      expect(dino).to be_valid
    end
  end

  describe 'Cage affinity validations' do
    it 'is valid to have two herbivores of different species in the same cage' do
      create(:dinosaur, :herbivore, species: 'Brachiosaurus', cage: 1)
      dino = create(:dinosaur, :herbivore, species: 'Stegosaurus', cage: 1)

      expect(dino).to be_valid
    end

    it 'is valid to have two carnivores of the same species in the same cage' do
      create(:dinosaur, :carnivore, species: 'Velociraptor', cage: 1)
      dino = create(:dinosaur, :carnivore, species: 'Velociraptor', cage: 1)

      expect(dino).to be_valid
    end

    it 'it is not valid to have different species of carnivores in the same cage' do
      create(:dinosaur, :carnivore, species: 'Velociraptor', cage: 1)

      dino = Dinosaur.new(name: 'Fred', species: 'Megalosaurus', cage: 1)
      dino.validate
      expect(dino.errors[:base]).to include('Cannot mix species of carnivores')
    end

    it 'is not valid to add a herbivore to a cage containing carnivores' do
      create(:dinosaur, :carnivore, species: :Velociraptor, cage: 1)

      dino = Dinosaur.new(name: 'Fred', species: 'Brachiosaurus', cage: 1)
      dino.validate
      expect(dino.errors[:base]).to include('Cage already contains carnivores')
    end
  end
end
