FactoryBot.define do
  factory :cage do
    capacity { rand(10) }
    dinosaur_count { 0 }

    trait :down do
      status { 'DOWN' }
    end

    trait :active do
      status { 'ACTIVE' }
    end
  end
end
