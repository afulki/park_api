FactoryBot.define do
  factory :dinosaur do
    name { Faker::Name.name }

    trait :carnivore do
      species { %w[Tyrannosaurus Velociraptor Spinosaurus Megalosaurus].sample }
    end

    trait :herbivore do
      species { %w[Brachiosaurus Stegosaurus Ankylosaurus Triceratops].sample }
    end
  end
end
