FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    name { Faker::Lorem.word }
    password { Faker::Internet.password }
  end
end
