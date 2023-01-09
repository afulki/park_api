# frozen_string_literal: true

class CageValidator < ActiveModel::Validator
  # This class validates that carnivores can only be in the same cage
  # and that there are no carnivores in the case when adding a herbivore
  def validate(record)
    return if record.cage.nil?

    dinos_in_cage = Dinosaur.in_cage(record.cage)

    if record.carnivore?
      validate_carnivores(record, dinos_in_cage)
    else
      validate_herbivores(record, dinos_in_cage)
    end
  end

  private

  def validate_carnivores(record, dinos)
    return if dinos.empty?
    return if dinos[0].species == record.species

    record.errors.add :base, 'Cannot mix species of carnivores'
  end

  def validate_herbivores(record, dinos)
    return if dinos.empty?
    return unless dinos[0].carnivore?

    record.errors.add :base, 'Cage already contains carnivores'
  end
end
