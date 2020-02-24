FactoryBot.define do
  factory :project do
    sequence(:name ) { |n| "Project#{n}" }
    description { "A test project" }
    due_on { 1.week.from_now }
    association :owner

    # メモ付きのプロジェクト
    trait :with_notes do
      after(:create) { |project| create_list(:note, 5, project: project) }
    end

    # 締切日が昨日のプロジェクト
    factory :project_due_yesterday do
      due_on 1.day.ago
    end

    # 締切日が今日のプロジェクト
    factory :project_due_today do
      due_on Date.current.in_time_zone
    end

    # 締切日が明日のプロジェクト
    factory :project_due_tomorrow do
      due_on 1.day.from_now
    end

    # 締切日が昨日のプロジェクト
    trait :due_yesterday do
      due_on 1.day.ago
    end

    # 締切日が今日のプロジェクト
    trait :due_today do
      due_on Date.current.in_time_zone
    end

    # 締切日が明日のプロジェクト
    trait :due_tomorrow do
      due_on 1.day.from_now
    end
  end
end
