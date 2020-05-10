FactoryBot.define do
  factory :note do
    message { "My important note" }
    association :project
    # association :user
    user { project.owner }

    trait :with_attachment do
      attachment { File.new("#{Rails.root}/spec/files/attachment.png") }
    end
  end
end
