# frozen_string_literal: true

# Cage definition
class CreateCages < ActiveRecord::Migration[7.0]
  def change
    create_table :cages do |t|
      t.integer :capacity
      t.string :status
      t.integer :dinosaur_count

      t.timestamps
    end
  end
end
