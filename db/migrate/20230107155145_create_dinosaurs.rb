# frozen_string_literal: true

class CreateDinosaurs < ActiveRecord::Migration[7.0]
  def change
    create_table :dinosaurs do |t|
      t.string :name
      t.string :species
      t.boolean :carnivore
      t.integer :cage

      t.timestamps
    end
  end
end
