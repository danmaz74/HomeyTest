FactoryBot.define do
  factory :project_history_item do
    item_type { 'user_comment' }

    project { FactoryBot.create(:project) }
    user { FactoryBot.create(:user) }
    source { user.name }

    content { Faker::Lorem.sentence }

    trait :status_change do
      item_type { 'status_change' }
      source { 'system' }

      user { nil }
    end
  end
end
