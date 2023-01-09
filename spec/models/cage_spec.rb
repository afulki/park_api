require 'rails_helper'

RSpec.describe Cage, type: :model do
  context 'validations' do
    before { build(:cage) }

    it do
      should validate_presence_of(:capacity)
      should validate_presence_of(:dinosaur_count)
    end
  end
end
