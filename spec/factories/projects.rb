FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "Project #{n}" }
    description { "A test project" }
    due_on { 1.week.from_now }
    association :owner
    # owner

    factory :project_due_yesterday do
      due_on { 1.day.ago }
    end

    trait :due_today do
      due_on { Time.zone.today }
    end

    factory :project_due_tommorow do
      due_on { 1.day.from_now }
    end

    trait :with_notes do
      after(:create) { |project| create_list(:note, 5, project: project) }
    end

    trait :invalid do
      name { nil }
    end
  end

  # factory :project_due_today, class: Project do
  #   sequence(:name) { |n| "Project #{n}" }
  #   description { "A test project" }
  #   due_on { Time.zone.today }
  #   association :owner
  #   # owner
  # end
end
