require 'rails_helper'

module Api
  module V1
    RSpec.describe DinosaursController, type: :controller do
      it { should route(:get, 'api/v1/dinosaurs').to(action: :index) }
      it { should route(:get, 'api/v1/dinosaurs/1').to(action: :show, id: 1) }
      it { should route(:post, 'api/v1/dinosaurs').to(action: :create)}
    end
  end
end
