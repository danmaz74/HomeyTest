FactoryBot.define do
  factory :project do
    owner { FactoryBot.create(:user) }

    name { Faker::Lorem.word }
  end
end
