# frozen_string_literal: true

# Knows all about cages
class Cage < ApplicationRecord
  attribute :dinosaur_count, :integer, default: 0
  attribute :capacity, :integer, default: 10
  attribute :status, :string, default: 'ACTIVE'

  # validations
  validates_presence_of :capacity, :dinosaur_count
  validates :dinosaur_count, numericality: {
    less_than_or_equal_to: :capacity,
    message: 'This cage is already full',
    allow_nil: false
  }, if: [proc { |a| a.capacity.present? }]

  scope :powered_on, -> { where(status: 'ACTIVE') }
  scope :powered_off, -> { where(status: 'DOWN') }

  def down?
    status == 'DOWN'
  end

  def active?
    status == 'ACTIVE'
  end
end
