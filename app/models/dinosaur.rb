# frozen_string_literal: true

require_relative 'validators/cage_validator'

# Knows everything about a Dinosaur
class Dinosaur < ApplicationRecord
  before_validation :set_carnivore

  CARNIVORES = %w[Tyrannosaurus Velociraptor Spinosaurus Megalosaurus].freeze
  HERBIVORES = %w[Brachiosaurus Stegosaurus Ankylosaurus Triceratops].freeze

  # validations
  validates_presence_of :name, :species, :cage
  validates_inclusion_of :species, in: CARNIVORES + HERBIVORES
  validates_with CageValidator

  def carnivore?
    carnivore
  end

  scope :in_cage, ->(cage) { where('cage = ?', cage) }

  private

  def set_carnivore
    self.carnivore = CARNIVORES.include? species
  end
end
